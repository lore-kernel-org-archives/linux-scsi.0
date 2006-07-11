From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: aic94xx status
Date: Mon, 10 Jul 2006 22:07:39 -0700
Message-ID: <20060711050739.GB7552@us.ibm.com>
References: <1152376067.12020.26.camel@mulgrave.il.steeleye.com> <20060710160915.GA30179@us.ibm.com> <1152548827.7275.20.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:23767 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S965042AbWGKFHg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 01:07:36 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6B57aJe025449
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2006 01:07:36 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6B57ZvM188410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2006 23:07:35 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6B57ZJV022248
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jul 2006 23:07:35 -0600
Content-Disposition: inline
In-Reply-To: <1152548827.7275.20.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>, "Tarte, Robert" <Robert_Tarte@adaptec.com>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Mon, 2006-07-10 at 09:09 -0700, Mike Anderson wrote:
> > Currently I am running a loaned SATA drive with the patch below. It
> > just
> > generates the "Unidentified device type" type message when it detects
> > a
> > SATA device and appears in my configuration to not cause any bad
> > things to
> > happen.
> 
> That seems to cover the directly attached case, thanks.
> 
> What happens if the SATA device is remote over an expander using STP?
> That seems to have a separate case in sas_ex_discover_end_dev.

I tried the SATA drive connected off a edge device prior to having to
return the device. I saw the devices address in the attached message, but
nothing else was printed. At least it did not cause any other issues.

-andmike
--
Michael Anderson
andmike@us.ibm.com
