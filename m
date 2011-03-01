From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: questions about blocklayoutdriver.ko
Date: Tue, 01 Mar 2011 16:30:02 +0200
Message-ID: <4D6D02EA.4070007@panasas.com>
References: <OBZUVMYJATHRCLVDQKALZPQUFOLW.09120171@bjtu.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:8577 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab1CAOaF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2011 09:30:05 -0500
In-Reply-To: <OBZUVMYJATHRCLVDQKALZPQUFOLW.09120171@bjtu.edu.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?GB2312?B?sNfLycHW?= <09120171@bjtu.edu.cn>
Cc: Jim Rees <rees@umich.edu>, peter honeyman <honey@citi.umich.edu>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Songlin Bai,

The following wiki page contains helps setting up the pnfs-block server
and client side deamon:
http://wiki.linux-nfs.org/wiki/index.php/PNFS_Block_Server_Setup_Instru=
ctions

I'm not sure it's completely updated with the most current information
so I'd appreciate if you could try using it and provide us with feedbac=
k for
any inaccuracies or missing parts.

Jim Rees, (Cc'ed here), currently has the most experience in this area.

Thanks,

Benny

On 2011-03-01 15:44, =B0=D7=CB=C9=C1=D6 wrote:
> Hi
>=20
> I am a postgraduate at BeiJing JiaoTong university in china. In our
> lab,including our professor,we are interested in PNFS.
>=20
> Now,we have been set up the test environment with the
> nfs_layout_nfsv41_files.ko, and it can run successfully.
>=20
> But,we do not konw how to use blocklayoutdirver.ko.
>=20
> Can you tell me something about how to use it?
>=20
> Thanks.
>=20
> Songlin Bai.
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
