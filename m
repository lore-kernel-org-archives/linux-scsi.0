From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: PROBLEM: kernel crashes on RAID1 drive error
Date: Tue, 16 Nov 2004 16:51:41 +0100
Message-ID: <20041116155141.GL3973@marowsky-bree.de>
References: <8FA83ADB-22E4-11D9-AC9C-0003934F6348@aol.com> <20041021084514.GY10531@suse.de> <4177BF22.7060208@steeleye.com> <20041021135557.GN10531@suse.de> <4177C13C.10007@steeleye.com> <20041021140236.GO10531@suse.de> <88F77D21-2443-11D9-AAEE-0003934F6348@aol.com> <91146D2E-2918-11D9-B6DC-0003934F6348@aol.com> <2BF4BB83-2E93-11D9-804F-0003934F6348@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:9940 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S262004AbUKPPvx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2004 10:51:53 -0500
Content-Disposition: inline
In-Reply-To: <2BF4BB83-2E93-11D9-804F-0003934F6348@mac.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rustad <mrustad@mac.com>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org

On 2004-11-04T12:56:01, Mark Rustad <mrustad@mac.com> wrote:

> I came up with a patch that seems to fix the kernel crashing on a RAI=
D1=20
> device failure problem. I do not have confidence that it really is th=
e=20
> correct fix, but I'm pretty sure that it is touching the right area.=20
> I'm sure someone more familiar with this area of the kernel will=20
> recognize from this what the correct fix is, if this is not it.=20
> Submitted for your consideration:

Hi Mark, checking back whether any better fix has since been proposed?


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
