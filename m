From: Samuel Silbory <samuel.silbory@hds.com>
Subject: RE: [Bug 187381] New: 4.9.-rc4 produces hundreds of unusable scsi
 devices.
Date: Wed, 9 Nov 2016 21:19:17 +0000
Message-ID: <5F2174A7F2A7FD43BEB9EFF9FF5229F0C7009B71@USINDEM103.corp.hds.com>
References: <bug-187381-11613@https.bugzilla.kernel.org/>,<1478724561.18853.1.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usindpps04.hds.com ([207.126.252.17]:32929 "EHLO
        usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbcKIVuS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 16:50:18 -0500
In-Reply-To: <1478724561.18853.1.camel@HansenPartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "bugzilla-daemon@bugzilla.kernel.org" <bugzilla-daemon@bugzilla.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Certainly I'll give it a try.=0A=
________________________________________=0A=
From: James Bottomley [James.Bottomley@HansenPartnership.com]=0A=
Sent: Wednesday, November 09, 2016 12:49 PM=0A=
To: bugzilla-daemon@bugzilla.kernel.org; linux-scsi@vger.kernel.org=0A=
Cc: Samuel Silbory=0A=
Subject: Re: [Bug 187381] New: 4.9.-rc4 produces hundreds of unusable scsi =
devices.=0A=
=0A=
On Wed, 2016-11-09 at 20:20 +0000, bugzilla-daemon@bugzilla.kernel.org=0A=
wrote:=0A=
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__bugzilla.kernel.or=
g_show-5Fbug.cgi-3Fid-3D187381&d=3DCwICaQ&c=3DDZ-EF4pZfxGSU6MfABwx0g&r=3D4F=
OU_7YnNtQNKWSdicj67DITRyD0V0NPxX2P7qBxsr8&m=3DqqYheGXoM4mBPxyZZ7HM1rugSFukV=
AVfEjl1ifhaoqU&s=3D67orQXH1IekXCew60eHDOmksAqiZIU69q0eGzoqiWMM&e=3D=0A=
>=0A=
>             Bug ID: 187381=0A=
>            Summary: 4.9.-rc4 produces hundreds of unusable scsi=0A=
> devices.=0A=
>            Product: SCSI Drivers=0A=
>            Version: 2.5=0A=
>     Kernel Version: 4.9-rc4=0A=
>           Hardware: All=0A=
>                 OS: Linux=0A=
>               Tree: Mainline=0A=
>             Status: NEW=0A=
>           Severity: normal=0A=
>           Priority: P1=0A=
>          Component: Other=0A=
>           Assignee: scsi_drivers-other@kernel-bugs.osdl.org=0A=
>           Reporter: samuel.silbory@hds.com=0A=
>         Regression: No=0A=
>=0A=
> Created attachment 244091=0A=
>   -->=0A=
> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__bugzilla.kernel.or=
g_attachment.cgi-3Fid-3D244091-26action-3Dedit&d=3DCwICaQ&c=3DDZ-EF4pZfxGSU=
6MfABwx0g&r=3D4FOU_7YnNtQNKWSdicj67DITRyD0V0NPxX2P7qBxsr8&m=3DqqYheGXoM4mBP=
xyZZ7HM1rugSFukVAVfEjl1ifhaoqU&s=3DypXf8FCNK77zZPf1gXuZlzQpRkGQWJ_WEGmWjqnX=
TOI&e=3D=0A=
> Debian's kernel log file.  Note that this contains functional boots=0A=
> with older=0A=
> kernels as well earlier in the file.=0A=
>=0A=
> With both my hand compiled 4.9-rc4 from kernel.org sources and=0A=
> Ubuntu's=0A=
> 4.9.0-040900rc4-generic the kernel creates hundred of useless=0A=
> /dev/sd??=0A=
> devices.  This system is fine with various 4.4, and 4.8 kernels.=0A=
>=0A=
> The logs are spammed with messages like these=0A=
> 2016-11-09T12:17:00.021765-08:00 Node001 kernel: [75590.503155] Dev=0A=
> sdjm:=0A=
> unable to read RDB block 1=0A=
> 2016-11-09T12:17:00.021767-08:00 Node001 kernel: [75590.503188]=0A=
>  sdjm: unable=0A=
> to read partition table=0A=
> 2016-11-09T12:17:00.021769-08:00 Node001 kernel: [75590.503191] sdjm:=0A=
> partition=0A=
> table beyond EOD, enabling native capacity=0A=
> 2016-11-09T12:17:00.021776-08:00 Node001 kernel: [75590.504463] sd=0A=
> 1:3:126:0:=0A=
=0A=
This was reported to the mailing list and should be fixed by this:=0A=
=0A=
https://urldefense.proofpoint.com/v2/url?u=3Dhttp-3A__marc.info_-3Fl-3Dlinu=
x-2Dscsi-26m-3D147868920429684&d=3DCwICaQ&c=3DDZ-EF4pZfxGSU6MfABwx0g&r=3D4F=
OU_7YnNtQNKWSdicj67DITRyD0V0NPxX2P7qBxsr8&m=3DqqYheGXoM4mBPxyZZ7HM1rugSFukV=
AVfEjl1ifhaoqU&s=3DKCePcDLsNpEqob1iEoGGCb5Qf-smnMYk4XsK62Sp0h4&e=3D=0A=
=0A=
We'll fast track this, but can you verify it fixes your issue.=0A=
=0A=
Thanks,=0A=
=0A=
James=0A=
=0A=
=0A=
