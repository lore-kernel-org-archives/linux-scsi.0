From: Andrew Vasquez <praka@san.rr.com>
Subject: Re: qlogic failover multipath
Date: Fri, 13 Sep 2002 15:28:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020913222835.GB4315@praka.local.home>
References: <20020906153437.GA2164@beaverton.ibm.com> <Pine.LNX.4.44.0209070822250.21784-100000@omega.s-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0209070822250.21784-100000@omega.s-tec.de>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 07 Sep 2002, Oktay Akbal wrote:

> On Fri, 6 Sep 2002, Mike Anderson wrote:
> 
> > You can edit the qla_settings.h file and set MPIO_SUPPORT to 1 or I
> > believe if you use the qla2x00src-v6.1b5-fo archive that this should
> > already be set to 1.
> 
> Thank you, I will try at Monday. It is set to 0 in b5.
> But my archive is named: qla2x00src-v6.1b5.tgz
> -fo seems to come only from enabling MPIO ?
>
The only functional difference between the -fo package referenced by 
Mike Anderson and the non-fo (qla2x00src-v6.1b5.tgz) available from
the QLogic download site is:

	o MPIO_SUPPORT always set to 1
	o Different README files.

Thus, multipathing support can be enabled with standard package.

Regards,
-- 
Andrew Vasquez | praka@san.rr.com |
	I prefer an accomidating vice to an obstinate virtue
DSS: 0x508316BB, FP: 79BD 4FAC 7E82 FF70 6C2B  7E8B 168F 5529 5083 16BB
