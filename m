From: Francois Petillon <fantec@proxad.net>
Subject: Re: Fw: 2.6.9-rc2-mm2: 3ware card info not in /proc/scsi
Date: Fri, 24 Sep 2004 10:24:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4153D9C6.3000205@proxad.net>
References: <20040923194322.78fb1c59.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fanfan.staff.proxad.net ([213.228.1.105]:17616 "EHLO
	fanfan.staff.proxad.net") by vger.kernel.org with ESMTP
	id S268589AbUIXIYj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Sep 2004 04:24:39 -0400
Received: from proxad.net (localhost [127.0.0.1])
	by fanfan.staff.proxad.net (Postfix) with ESMTP id 571F035A72E
	for <linux-scsi@vger.kernel.org>; Fri, 24 Sep 2004 10:24:38 +0200 (CEST)
In-Reply-To: <20040923194322.78fb1c59.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Andrew Morton wrote:
> I have a 3Ware-7500 series card.  I was trying the 2.6.9-rc2-mm2 kern=
el
> and discovered that the 3dmd utility was not working.  A little pokin=
g
> around revealed that the cause was because the 3Ware directory was no=
t
> in /proc/scsi, even though I have CONFIG_SCSI_PROC_FS=3Dy in my confi=
g
> file.  The 3dmd utility works fine with mainline 2.6.9-rc2 and it wor=
ked
> with the 2.6.8-mm series of kernels.  Those kernels have a 3w-xxxx
> directory in /proc/scsi.

You need to update 3Ware tools using "engeneering phase software" at :=20
http://www.3ware.com/support/index.asp

   Fran=E7ois
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
