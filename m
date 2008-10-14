From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: LSISAS1068 ioerr_cnt 0x1 on clean boot up
Date: Tue, 14 Oct 2008 09:36:55 -0600
Message-ID: <660360F4F2570145BD872F298951B17A5CA5E17B@cosmail03.lsi.com>
References: <6A4D764DC1BDE14495DA8DC60A3D69531F8DA650EE@hkgmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61426 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbYJNPhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Oct 2008 11:37:09 -0400
In-Reply-To: <6A4D764DC1BDE14495DA8DC60A3D69531F8DA650EE@hkgmail01.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, Abhijit Paithankar <apaithan@akamai.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tuesday, October 14, 2008 12:46 AM, Prakash, Sathya wrote:
> I couldn't check with 1030 but with mptsas, with SATA drives
> with the patch sent by Eric, I am able to see the err_cnt not
> getting incremented to 1.
>

Sathya and Abhijit - impossible, the function sas_read_port_mode_page is implemented in the sas transport layer. Its not called nor implemented in SPI.

mode page 0x19, is the protocal specific port mode page for SAS SSP.  You can find this defined in the SAS spec, look at section 10.2.7.4
URL: http://www.t10.org/ftp/t10/drafts/sas2/sas2r14e.pdf

Eric Moore
