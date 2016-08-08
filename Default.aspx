<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width,user-scalable=no,initial-scale=1.0,maximum-scale=1.0,minimun-scale=1.0" />
    <title><%= title %>客户开户申请表</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/select2.min.css" rel="stylesheet" />
    <link href="Styles/style.css" rel="stylesheet" />
</head>
<body>
    <form runat="server">
        <div class="container">
            <div id="myForm" style="margin-top: 20px;">
                <div class="row">
                    <label for="name" class="col-xs-4 formLabel">姓名</label>
                    <input type="text" id="name" name="name" class="col-xs-8" value="lvbiao" />
                </div>
                <div class="row">
                    <label for="phone" class="col-xs-4 formLabel">手机号码</label>
                    <input type="text" id="phone" name="phone" class="col-xs-8" value="13524259846" />
                </div>
                <div class="row">
                    <label for="cardNo" class="col-xs-4 formLabel">身份证号码</label>
                    <input type="text" id="cardNo" name="cardNo" class="col-xs-8" value="412701198206050513" />
                </div>
                <div class="row">
                    <label for="bankName" class="col-xs-4 formLabel">开户银行</label>
                    <select id="bankSelect" name="bankSelect" class="form-control col-xs-8" style="width: 66.6%;">
                        <option value="10" selected="selected">工商银行</option>
                        <option value="18">民生银行</option>
                        <option value="41">平安银行</option>
                    </select>
                </div>
                <div class="row">
                    <label for="accountNo" class="col-xs-4 formLabel">银行账号</label>
                    <input type="text" id="accountNo" name="accountNo" class="col-xs-8" value="1234567890" />
                </div>
                <div class="row">
                    <label for="brokerSelect" class="col-xs-4 formLabel">营业部</label>
                    <select id="brokerSelect" name="brokerSelect" class="form-control col-xs-8" style="width: 66.6%;">
                        <% =brokerSelectDatas %>
                    </select>
                </div>
                <div class="row">
                    <label for="cardPhoto" class="col-xs-4 formLabel">身份证正面照</label>
                    <a href="#" class="btn btn-primary btn-sm col-xs-8" style="float: right;" onclick="document.getElementById('files').click();">点击选择图片(小于500k)</a>
                    <input style="display: none;" id="files" name="files" type="file" onchange="fileChangeEvent(this)" />
                </div>
                <div class="row">
                    <img id="captcha" style="height: 30px; line-height: 30px;" class="col-xs-4" />
                    <input type="text" id="num" name="num" class="col-xs-4 formLabel" placeholder="请输入验证码" />
                    <a href="#" class="btn btn-primary btn-sm col-xs-4" onclick="refreshCaptcha()">重新获取验证码</a>
                </div>
                <input type="hidden" name="selectp" value="<%= selectp%>" />
                <input type="hidden" name="address1" value="<%= address1%>" />
                <input type="hidden" name="address" value="<%= address%>" />
                <input type="hidden" name="brokerId" value="<%= brokerId%>" />
                <div class="row" style="border-bottom: none;">
                    <a href="#" id="btnSubmit" class="btn btn-primary btn-block">提交</a>
                </div>
            </div>
            <div id="tradePage" style="display: none;">
                <p style="margin-top: 5px; font-weight: bold;">交易平台会在1-2个工作日内进行审核(交易日5点前注册，当日审核完毕，5点后注册，第二天审核完毕，非交易日注册，下个交易日审核)。</p>
                <div class="note">
                    <div>特别提醒：</div>
                    <div>1、您的初始交易密码为证件后六位；</div>
                    <div>2、本页内容包含了您的相关开户信息，建议妥善记录、保存；</div>
                    <div>3、如有疑问请拨：400-878-5019。</div>
                </div>

                <div class="info">
                    <div class="info_title row">
                        投资者信息表
                    </div>
                    <div class="row inforow">
                        <div class="col-xs-4">
                            投资者姓名
                        </div>
                        <div class="col-xs-8" id="tradName">
                        </div>
                    </div>
                    <div class="row inforow">
                        <div class="col-xs-4">
                            证件号码
                        </div>
                        <div class="col-xs-8" id="tradCardNo">
                        </div>
                    </div>
                    <div class="row inforow">
                        <div class="col-xs-4">
                            交易账号
                        </div>
                        <div class="col-xs-8" id="tradNo">
                        </div>
                    </div>
                    <div class="row inforow">
                        <div class="col-xs-4">
                            手机号码
                        </div>
                        <div class="col-xs-8" id="tradPhone">
                        </div>
                    </div>
                    <div class="row inforow">
                        <div class="col-xs-4">
                            机构名称
                        </div>
                        <div class="col-xs-8" id="tradJG">
                        </div>
                    </div>
                    <div class="row inforow">
                        <div class="col-xs-4">
                            机构编号
                        </div>
                        <div class="col-xs-8" id="tradBH">
                        </div>
                    </div>
                    <div class="row inforow">
                        <div class="col-xs-4">
                            联系方式
                        </div>
                        <div class="col-xs-8" id="tradLX">
                        </div>
                    </div>
                    <div class="row inforow">
                        <div class="col-xs-4">
                            通讯地址
                        </div>
                        <div class="col-xs-8" id="tradAddress">
                        </div>
                    </div>
                </div>


            </div>
        </div>
    </form>
    <script src="Scripts/jquery-3.1.0.min.js"></script>
    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/select2.min.js"></script>
    <script src="Scripts/zh-CN.js"></script>
    <script>
        //开户行
        var bankId;
        var bankSelect;
        //营业部
        var brokerSelect;
        var brokerId;
        var img;//验证码图片
        var isUploaded = true;
        var filesToUpload = [];

        function refreshCaptcha() {
            $.post("Handlers/Handler.ashx", { method: "getPic" }, function (img) {
                $("#captcha").attr("src", "/yzm/" + img);
            });
        }

        $(function () {
            img = $("#captcha");
            refreshCaptcha();

            bankSelect = $('#bankSelect');
            brokerSelect = $('#brokerSelect');
            bankSelect.select2({
                minimumResultsForSearch: Infinity
            });
            brokerSelect.select2({
                minimumResultsForSearch: Infinity,
                placeholder: '请选择一个营业部'
            });
            $("#btnSubmit").click(function () {
                var brokerId = brokerSelect.val();
                var bankId = bankSelect.val();
                //alert(bankId);
                var name = $.trim($("#name").val());
                if (!name) {
                    $("#name").notify("姓名不能为空!", { position: "bottom center" });
                    return false;
                }
                var phone = $.trim($("#phone").val());
                if (!phone) {
                    $("#phone").notify("手机号不能为空!", { position: "bottom center" });
                    return false;
                }
                var cardNo = $.trim($("#cardNo").val());
                if (!cardNo) {
                    $("#cardNo").notify("身份证号不能为空!", { position: "bottom center" });
                    return false;
                }
                var accountNo = $.trim($("#accountNo").val());
                if (!accountNo) {
                    $("#accountNo").notify("银行账号不能为空!", { position: "bottom center" });
                    return false;
                }
                if (!brokerId) {
                    $("#brokerSelect").notify("营业部不能为空!", { position: "bottom center" });
                    return false;
                }
                var num = $.trim($("#num").val());
                if (!num) {
                    $("#num").notify("验证码不能为空!", { position: "bottom center" });
                    return false;
                }

                var url = "https://z.hbyoubi.com:16919/SelfOpenAccount/firmController.fir?funcflg=eidtFirm";

                var data = { name: name, registeredPhoneNo: phone, attach: filesToUpload[0], method: 'dataInfo' };

                var formData = new FormData();

                for (var i = 0; i < filesToUpload.length; i++) {
                    formData.append("attach", filesToUpload[i]);
                }
                formData.append("method", "dataInfo");
                //添加参数
                //   name: this.name,
                formData.append('name', name);
                //   registeredPhoneNo: this.registeredPhoneNo,
                formData.append('registeredPhoneNo', phone);
                //   fax: '',
                formData.append('fax', '');
                //   cardType: '1', //证件类型：身份证
                formData.append('cardType', '1');
                //   cardNumber: this.cardNumber,
                formData.append('cardNumber', cardNo);
                //   email: '',
                formData.append('email', '');
                //   recommendBankCode: this.recommendBankCode,
                formData.append('recommendBankCode', bankId);
                //   bankAccount: this.bankAccount,
                formData.append('bankAccount', accountNo);
                //   postCode: '',
                formData.append('postCode', '');
                //   selectp: '',
                formData.append('selectp', '<%= selectp%>');
                //   address1: '',
                formData.append('address1', '<%= address1%>');
                //   address: '',
                formData.append('address', '<%= address%>');
                //   contactMan: '',
                formData.append('contactMan', name);
                //   brokerId1: '',
                formData.append('brokerId1', '');
                //   type: '',
                formData.append('type', '3');
                //   industryCode: '',
                formData.append('industryCode', '');
                //   zoneCode: '',
                formData.append('zoneCode', '');
                //   organizationCode: '',
                formData.append('organizationCode', '');
                //   corporateRepresentative: '',
                formData.append('corporateRepresentative', '');
                //   brokerId: '20051',
                formData.append('brokerId', '<%= brokerId%>');
                //   brokerageid: '',
                formData.append('brokerageid', brokerId);
                //   yanzhengma: this.captcha,
                formData.append('yanzhengma', num);
                //   ck: 'on'
                formData.append('ck', 'on');


                $.ajax({
                    url: "Handlers/Handler.ashx",
                    data: formData,
                    dataType: "html",
                    type: "POST",
                    /**
                     * 必须false才会避开jQuery对 formdata 的默认处理
                     * XMLHttpRequest会对 formdata 进行正确的处理
                     */
                    processData: false,
                    /**
                     *必须false才会自动加上正确的Content-Type
                     */
                    contentType: false,
                    success: function (data) {
                        data = $.parseJSON(data);
                        if (data.isSuccess == "0") {
                            //报错了
                            alert(data.msg);
                            $("#tradePage").hide();
                            $("#myForm").show();
                        }
                        else {
                            $("#myForm").hide();

                            $("#tradName").text(data.name);
                            $("#tradCardNo").text(data.cardNumber);
                            $("#tradNo").text(data.tradeNo);
                            $("#tradPhone").text(data.phone);
                            $("#tradJG").text(data.jgmc);
                            $("#tradBH").text(data.jgbh);
                            $("#tradLX").text(data.lx);
                            $("#tradAddress").text(data.address);

                            $("#tradePage").show();
                        }
                    },
                    error: function (data) {
                        alert("error:" + data.responseText);
                    }
                });
            });
        });

        function resizeFile(file) {
            var reader = new FileReader();
            reader.readAsDataURL(file);
            var image = document.createElement('img');
            reader.onload = function (e) {
                {
                    image.src = e.target.result;
                    image.onload = function () {
                        var canvas = document.createElement('canvas'),
                                     max_size = 544,
                                     width = image.width,
                                     height = image.height;
                        if (width > height) {
                            if (width > max_size) {
                                height *= max_size / width;
                                width = max_size;
                            }
                        } else {
                            if (height > max_size) {
                                width *= max_size / height;
                                height = max_size;
                            }
                        }
                        canvas.width = width;
                        canvas.height = height;
                        canvas.getContext('2d').drawImage(image, 0, 0, width, height);
                        var dataUrl = canvas.toDataURL('image/jpeg');
                        var resizedImage = dataURLToBlob(dataUrl);
                        var myFile = blobToFile(resizedImage, file.name);
                        filesToUpload.push(myFile);
                    };
                };
            }
        }

        function dataURLToBlob(dataURL) {
            var BASE64_MARKER = ';base64,';
            if (dataURL.indexOf(BASE64_MARKER) == -1) {
                var parts = dataURL.split(',');
                var contentType = parts[0].split(':')[1];
                var raw = parts[1];

                return new Blob([raw], { type: contentType });
            }

            var parts = dataURL.split(BASE64_MARKER);
            var contentType = parts[0].split(':')[1];
            var raw = window.atob(parts[1]);
            var rawLength = raw.length;

            var uInt8Array = new Uint8Array(rawLength);

            for (var i = 0; i < rawLength; ++i) {
                uInt8Array[i] = raw.charCodeAt(i);
            }

            return new Blob([uInt8Array], { type: contentType });
        }

        function blobToFile(b, fileName) {
            b.lastModifiedDate = new Date();
            b.name = fileName;
            return b;
        }

        function checkResult(response) {
            var idex = response.indexOf('交易会员入市协议');
            if (idex > 0) //说明返回页面包含入市协议 流程正确
            {
                return "ok";
            } else //返回页面不包含入市协议 说明当前页面发生错误
            {
                var start = response.indexOf("alert('");
                var end = response.indexOf("')</scr" + "ipt>")
                var errMsg = response.substring(start + 7, end);
                return errMsg;
            }
        }

        function parseResult(data) {
            var idex = data.indexOf('<td>交易账号</td>');
            if (idex > 0) {
                var telIndex = data.indexOf('<td>手机号码</td>');
                var tradeNo = data.substring(idex + 23, telIndex - 11);
                return tradeNo;
            } else {
                return "error";
            }
        }

        function fileChangeEvent(fileInput) {
            // this.isUploaded = true;
            // this.filesToUpload = [];

            for (var i = 0; i < fileInput.files.length; i++) {
                if (fileInput.files[i].size > (1024 * 500)) {
                    resizeFile(fileInput.files[i]);
                }
                else {
                    filesToUpload.push(fileInput.files[i]);
                }
            }
        }
    </script>
</body>
</html>
