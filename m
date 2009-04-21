From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 0/14 - 2nd post] mpt2sas: driver version 01.100.02.00
Date: Tue, 21 Apr 2009 14:03:25 -0700
Message-ID: <660360F4F2570145BD872F298951B17A76BCB4B3@cosmail03.lsi.com>
References: <1240327523.9408.1.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og58.obsmtp.com ([64.18.14.181]:46060 "EHLO
	chip3og58.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbZDUVDa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 17:03:30 -0400
In-Reply-To: <1240327523.9408.1.camel@mulgrave.int.hansenpartnership.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tuesday, April 21, 2009 9:25 AM, James Bottomley wrote: 
> On Tue, 2009-04-21 at 08:08 -0700, Moore, Eric wrote:
> > James - Can you please push these patchs into 2.6.30-rc ?
> 
> OK, so separate the patches into bug fixes (or -rc) and features (for
> next merge window).  T10 DIF is clearly a feature as is lun reset
> support and driver name in ioctl and updating the functional naming
> conventions.
> 

In my opinion the "driver name in ioctl" is a bug fix becuase the application doesnt' load without recognizing mpt2sas naming in the ioctl.   This is there in the mptsas driver, however I missed it when I ported the code over to mpt2sas.

I will repost the set of patch's minus the T10 DIF, lun reset, and functional renaming.

Eric






