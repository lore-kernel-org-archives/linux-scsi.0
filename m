From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Which Version of the aacraid driver shall I use?
Date: Tue, 21 Dec 2004 11:31:01 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B909934@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:6340 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261793AbULUQb1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2004 11:31:27 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Florian G. Pflug" <fgp@phlo.org>, linux-scsi@vger.kernel.org

1) The kernel.org driver is `good to go' with most of the mitigations
for H/W and F/W weirdness. The adaptec branch (1.1.5) of the aacraid
driver supports 2.4 and 2.6 kernels for continuing support, with all the
added-value features that OEMs have demanded we provide (Certification
match testing, CSMI, Hot add of arrays, Busy checking, Performance tuned
interfaces for advanced Firmware). The current crop of Firmware has only
a slight improvement in performance, the latest Firmware that should be
released shortly is a significant improvement when paired with the 1.1.5
driver; we will be pushing the interface changes in the New Year and
once Mark Haverkamp has returned. Acquiring the sources from me is more
timely than the one on the adaptec web site.

My recommendation is to stick with the one in the kernel with the
current crop of firmware. Do not confuse the versions of the drivers,
the 1.1.2-lk2 driver in the kernel is `close to' the 1.1.4-2322 driver
as released by Adaptec.

2) I flash via the add-on UART interface rather than via the aaccli or
afu commands, I would recommend working this via tech support or I may
end up leading you astray ;-/. The afu utility knows which ufi files to
pick up I believe, I have seen it done and it appeared painless.

3) No source for command line utility. It is really called aaccli, as
afacli is the Dell branded version. The tool is embedded inside the
management application packages available for download from adaptec. I
do not recall it being offered separately.

As an aside, I recommend the latest downloadable F/W for the 2200S,
there has been some `instability' in the earlier stuff.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Florian G. Pflug
Sent: Monday, December 20, 2004 12:48 PM
To: linux-scsi@vger.kernel.org
Subject: Which Version of the aacraid driver shall I use?

Hi

I have a few questions regarding the aacraid driver. Sorry if this is 
explained in some FAQ somewhere - I googled for an hour or so, and did't

find the information I need.

.) Which Version of the aacraid driver is recommended for a production 
system? I'm running a (vanilla) linux 2.6.9 kernel, and am wondering if 
I should go with the included aacraid driver, or use the aacraid 1.1.5 
driver available on www.adaptec.com? My controller is an Adaptec 2200S.

.) How does one upgrade the firmware, if there is no windows 
installation on the machine? (The archive with firmware version 7349 
contains 4 .ufi files, and an afu.exe - probably AdapctedFlashUtility, 
or something :-( ).

.) There seems to be a cli app for configuring aacraid controllers 
called afacli, but I can't find a way to download it anywhere? Does 
anyone have a link to either source or binary of this program?

greetings, Florian Pflug

PS: Please reply to me directly, as I am not on this list.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
