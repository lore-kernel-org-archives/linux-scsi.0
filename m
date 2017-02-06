From: ojab <ojab@ojab.ru>
Subject: Re: [PATCH V2] mpt3sas: disable ASPM for MPI2 controllers
Date: Mon, 6 Feb 2017 12:55:04 +0000
Message-ID: <0bdef432-e902-406c-1ccb-420e6f198c1c@ojab.ru>
References: <20161228110524.7516-1-ojab@ojab.ru>
 <73a398a7-bde4-d337-0954-bc0f8d2f3752@ojab.ru>
 <dd9f95e5-0812-521b-e060-f0fdf7283348@ojab.ru>
 <13e199bd-400f-d2e3-7896-d45c07bede51@ojab.ru>
 <CAK=zhgp9K+JKAb8RrR_1vNcf-Y0XoR7174nb5YBcnZdCbd7rAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------D7D774F5C79B5DFDAA5FBCEC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35248 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbdBFMzT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 07:55:19 -0500
Received: by mail-lf0-f68.google.com with SMTP id v186so3889540lfa.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 04:55:13 -0800 (PST)
In-Reply-To: <CAK=zhgp9K+JKAb8RrR_1vNcf-Y0XoR7174nb5YBcnZdCbd7rAw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------D7D774F5C79B5DFDAA5FBCEC
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2017/02/06 12:02, Sreekanth Reddy wrote:
> Hi Ojab,
>
> Can I get output of 'lspci -vvv -s' for LSI SAS2 card?
>
> On my Supermicro system, I have enabled ASPM in system BIOS but still
> in lspci output I see this ASPM was disabled for my SAS2 HBA card
> which has Phase19 firmware (i.e. 19.00.00.00) as shown below,
>
[snip]
>
> So, Can you also try once with Phase19 firmware.

How can I downgrade firmware? Right now I have FW 20.00.07.00 installed 
(`lspci` output can be found in the attached file), `sas2flash -fwall 
[P19_firmaware.bin]` tells me:
 >ERROR: Cannot downgrade NVDATA version 14.01.00.06
 >       to 11.00.110000.00.
 >
 >ERROR: Failed to get valid NVDATA image from File!

and `sas2flash -e 6` tells me
 >ERROR: Erase Flash Operation Failed!

//wbr ojab

--------------D7D774F5C79B5DFDAA5FBCEC
Content-Type: text/plain; charset=UTF-8;
 name="lspci_nopatch_P20.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lspci_nopatch_P20.txt"

MDI6MDAuMCBTZXJpYWwgQXR0YWNoZWQgU0NTSSBjb250cm9sbGVyOiBMU0kgTG9naWMgLyBT
eW1iaW9zIExvZ2ljIFNBUzIzMDggUENJLUV4cHJlc3MgRnVzaW9uLU1QVCBTQVMtMiAocmV2
IDA1KQoJU3Vic3lzdGVtOiBMU0kgTG9naWMgLyBTeW1iaW9zIExvZ2ljIERldmljZSAzMDIw
CglDb250cm9sOiBJL08rIE1lbSsgQnVzTWFzdGVyKyBTcGVjQ3ljbGUtIE1lbVdJTlYtIFZH
QVNub29wLSBQYXJFcnItIFN0ZXBwaW5nLSBTRVJSKyBGYXN0QjJCLSBEaXNJTlR4KwoJU3Rh
dHVzOiBDYXArIDY2TUh6LSBVREYtIEZhc3RCMkItIFBhckVyci0gREVWU0VMPWZhc3QgPlRB
Ym9ydC0gPFRBYm9ydC0gPE1BYm9ydC0gPlNFUlItIDxQRVJSLSBJTlR4LQoJTGF0ZW5jeTog
MCwgQ2FjaGUgTGluZSBTaXplOiA2NCBieXRlcwoJSW50ZXJydXB0OiBwaW4gQSByb3V0ZWQg
dG8gSVJRIDE5CglSZWdpb24gMDogSS9PIHBvcnRzIGF0IGMwMDAgW3NpemU9MjU2XQoJUmVn
aW9uIDE6IE1lbW9yeSBhdCBmZTdmMDAwMCAoNjQtYml0LCBub24tcHJlZmV0Y2hhYmxlKSBb
c2l6ZT02NEtdCglSZWdpb24gMzogTWVtb3J5IGF0IGZlNzgwMDAwICg2NC1iaXQsIG5vbi1w
cmVmZXRjaGFibGUpIFtzaXplPTI1NktdCglFeHBhbnNpb24gUk9NIGF0IGZlNjAwMDAwIFtk
aXNhYmxlZF0gW3NpemU9MU1dCglDYXBhYmlsaXRpZXM6IFs1MF0gUG93ZXIgTWFuYWdlbWVu
dCB2ZXJzaW9uIDMKCQlGbGFnczogUE1FQ2xrLSBEU0ktIEQxKyBEMisgQXV4Q3VycmVudD0w
bUEgUE1FKEQwLSxEMS0sRDItLEQzaG90LSxEM2NvbGQtKQoJCVN0YXR1czogRDAgTm9Tb2Z0
UnN0KyBQTUUtRW5hYmxlLSBEU2VsPTAgRFNjYWxlPTAgUE1FLQoJQ2FwYWJpbGl0aWVzOiBb
NjhdIEV4cHJlc3MgKHYyKSBFbmRwb2ludCwgTVNJIDAwCgkJRGV2Q2FwOglNYXhQYXlsb2Fk
IDQwOTYgYnl0ZXMsIFBoYW50RnVuYyAwLCBMYXRlbmN5IEwwcyA8NjRucywgTDEgPDF1cwoJ
CQlFeHRUYWcrIEF0dG5CdG4tIEF0dG5JbmQtIFB3ckluZC0gUkJFKyBGTFJlc2V0KwoJCURl
dkN0bDoJUmVwb3J0IGVycm9yczogQ29ycmVjdGFibGUrIE5vbi1GYXRhbCsgRmF0YWwrIFVu
c3VwcG9ydGVkKwoJCQlSbHhkT3JkLSBFeHRUYWcrIFBoYW50RnVuYy0gQXV4UHdyLSBOb1Nu
b29wKyBGTFJlc2V0LQoJCQlNYXhQYXlsb2FkIDEyOCBieXRlcywgTWF4UmVhZFJlcSA1MTIg
Ynl0ZXMKCQlEZXZTdGE6CUNvcnJFcnIrIFVuY29yckVyci0gRmF0YWxFcnItIFVuc3VwcFJl
cSsgQXV4UHdyLSBUcmFuc1BlbmQtCgkJTG5rQ2FwOglQb3J0ICMwLCBTcGVlZCA4R1Qvcywg
V2lkdGggeDgsIEFTUE0gTDBzLCBFeGl0IExhdGVuY3kgTDBzIDw2NG5zLCBMMSA8MXVzCgkJ
CUNsb2NrUE0tIFN1cnByaXNlLSBMTEFjdFJlcC0gQndOb3QtCgkJTG5rQ3RsOglBU1BNIEww
cyBFbmFibGVkOyBSQ0IgNjQgYnl0ZXMgRGlzYWJsZWQtIENvbW1DbGsrCgkJCUV4dFN5bmNo
LSBDbG9ja1BNLSBBdXRXaWREaXMtIEJXSW50LSBBdXRCV0ludC0KCQlMbmtTdGE6CVNwZWVk
IDVHVC9zLCBXaWR0aCB4OCwgVHJFcnItIFRyYWluLSBTbG90Q2xrKyBETEFjdGl2ZS0gQldN
Z210LSBBQldNZ210LQoJCURldkNhcDI6IENvbXBsZXRpb24gVGltZW91dDogUmFuZ2UgQkMs
IFRpbWVvdXREaXMrLCBMVFItLCBPQkZGIE5vdCBTdXBwb3J0ZWQKCQlEZXZDdGwyOiBDb21w
bGV0aW9uIFRpbWVvdXQ6IDUwdXMgdG8gNTBtcywgVGltZW91dERpcy0sIExUUi0sIE9CRkYg
RGlzYWJsZWQKCQlMbmtDdGwyOiBUYXJnZXQgTGluayBTcGVlZDogOEdUL3MsIEVudGVyQ29t
cGxpYW5jZS0gU3BlZWREaXMtCgkJCSBUcmFuc21pdCBNYXJnaW46IE5vcm1hbCBPcGVyYXRp
bmcgUmFuZ2UsIEVudGVyTW9kaWZpZWRDb21wbGlhbmNlLSBDb21wbGlhbmNlU09TLQoJCQkg
Q29tcGxpYW5jZSBEZS1lbXBoYXNpczogLTZkQgoJCUxua1N0YTI6IEN1cnJlbnQgRGUtZW1w
aGFzaXMgTGV2ZWw6IC0zLjVkQiwgRXF1YWxpemF0aW9uQ29tcGxldGUtLCBFcXVhbGl6YXRp
b25QaGFzZTEtCgkJCSBFcXVhbGl6YXRpb25QaGFzZTItLCBFcXVhbGl6YXRpb25QaGFzZTMt
LCBMaW5rRXF1YWxpemF0aW9uUmVxdWVzdC0KCUNhcGFiaWxpdGllczogW2QwXSBWaXRhbCBQ
cm9kdWN0IERhdGEKCQlOb3QgcmVhZGFibGUKCUNhcGFiaWxpdGllczogW2E4XSBNU0k6IEVu
YWJsZS0gQ291bnQ9MS8xIE1hc2thYmxlLSA2NGJpdCsKCQlBZGRyZXNzOiAwMDAwMDAwMDAw
MDAwMDAwICBEYXRhOiAwMDAwCglDYXBhYmlsaXRpZXM6IFtjMF0gTVNJLVg6IEVuYWJsZSsg
Q291bnQ9MTYgTWFza2VkLQoJCVZlY3RvciB0YWJsZTogQkFSPTEgb2Zmc2V0PTAwMDBlMDAw
CgkJUEJBOiBCQVI9MSBvZmZzZXQ9MDAwMGYwMDAKCUNhcGFiaWxpdGllczogWzEwMCB2Ml0g
QWR2YW5jZWQgRXJyb3IgUmVwb3J0aW5nCgkJVUVTdGE6CURMUC0gU0RFUy0gVExQLSBGQ1At
IENtcGx0VE8tIENtcGx0QWJydC0gVW54Q21wbHQtIFJ4T0YtIE1hbGZUTFAtIEVDUkMtIFVu
c3VwUmVxLSBBQ1NWaW9sLQoJCVVFTXNrOglETFAtIFNERVMtIFRMUC0gRkNQLSBDbXBsdFRP
LSBDbXBsdEFicnQtIFVueENtcGx0LSBSeE9GLSBNYWxmVExQLSBFQ1JDLSBVbnN1cFJlcS0g
QUNTVmlvbC0KCQlVRVN2cnQ6CURMUCsgU0RFUysgVExQLSBGQ1ArIENtcGx0VE8tIENtcGx0
QWJydC0gVW54Q21wbHQtIFJ4T0YrIE1hbGZUTFArIEVDUkMtIFVuc3VwUmVxLSBBQ1NWaW9s
LQoJCUNFU3RhOglSeEVycisgQmFkVExQLSBCYWRETExQKyBSb2xsb3Zlci0gVGltZW91dCsg
Tm9uRmF0YWxFcnItCgkJQ0VNc2s6CVJ4RXJyLSBCYWRUTFAtIEJhZERMTFAtIFJvbGxvdmVy
LSBUaW1lb3V0LSBOb25GYXRhbEVycisKCQlBRVJDYXA6CUZpcnN0IEVycm9yIFBvaW50ZXI6
IDAwLCBHZW5DYXAtIENHZW5Fbi0gQ2hrQ2FwLSBDaGtFbi0KCUNhcGFiaWxpdGllczogWzFl
MCB2MV0gIzE5CglDYXBhYmlsaXRpZXM6IFsxYzAgdjFdIFBvd2VyIEJ1ZGdldGluZyA8Pz4K
CUNhcGFiaWxpdGllczogWzE5MCB2MV0gIzE2CglDYXBhYmlsaXRpZXM6IFsxNDggdjFdIEFs
dGVybmF0aXZlIFJvdXRpbmctSUQgSW50ZXJwcmV0YXRpb24gKEFSSSkKCQlBUklDYXA6CU1G
VkMtIEFDUy0sIE5leHQgRnVuY3Rpb246IDAKCQlBUklDdGw6CU1GVkMtIEFDUy0sIEZ1bmN0
aW9uIEdyb3VwOiAwCglLZXJuZWwgZHJpdmVyIGluIHVzZTogbXB0M3NhcwoJS2VybmVsIG1v
ZHVsZXM6IG1wdDNzYXMKCg==
--------------D7D774F5C79B5DFDAA5FBCEC--
