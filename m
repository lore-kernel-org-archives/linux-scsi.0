From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len (resend)
Date: Fri, 28 Apr 2006 16:21:02 -0500
Message-ID: <1146259262.5251.92.camel@mulgrave.il.steeleye.com>
References: <200604172240.k3HMes2V010154@d01av01.pok.ibm.com>
	 <44522672.5010607@us.ibm.com>
	 <1146237433.5251.7.camel@mulgrave.il.steeleye.com>
	 <44525CBE.1030409@us.ibm.com>
	 <1146249006.5251.64.camel@mulgrave.il.steeleye.com>
	 <44526702.1010400@us.ibm.com>
	 <1146257803.5251.82.camel@mulgrave.il.steeleye.com>
	 <44528508.3060003@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <44528508.3060003@us.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: brking@us.ibm.com
Cc: linux-scsi@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2006-04-28 at 16:11 -0500, Brian King wrote:
> I suppose the only real exposure then would be someone doing passthru
> commands in which we could argue that userspace should be smart enough
> not to do things like this.
> 
> Going along with that argument, there's really no good reason for
> libata to be playing games with scsi_host->max_cmd_len based on
> the attached devices.

Exactly!  The parameter documents the HBA limit, which is something we
wouldn't be able to work out heuristically.  The SCSI operating model
has good heuristics for getting the right command size to devices
(although we can always add something if more there's a demonstrated
problems).

James


