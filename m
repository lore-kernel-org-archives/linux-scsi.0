From: Howard Thomson <howard.thomson@dial.pipex.com>
Subject: Wangtek 5150EQ SCSI-1 QIC-150 tape drive -- not detected
Date: Sat, 30 Jan 2010 23:17:04 +0000
Message-ID: <201001302317.04550.howard.thomson@dial.pipex.com>
Reply-To: howard.thomson@dial.pipex.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:18578
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753588Ab0A3XRJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Jan 2010 18:17:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I have a Wangtek 5150EQ tape drive for 150Mb QIC tape cartridges, last used
some ten years ago, which I would like to get working to read off some old tapes
before I finally move it on [sell, recycle, whatever ...]

It was working when removed from its original PC, connected to a Wangtek ISA
SCSI card, which I still have.

I am currently attempting to access it using an Adaptec AHA2940U adaptor, which
is being recognised as a host adaptor [AIC-7861] by Knoppix.

'dmesg' shows many messages of the form: 'Someone reset channel A'.

It also shows: "Driver 'st' needs updating, please use bus_type methods".

Would trying any later software be likely to fix such problems, or is a complete
failure to detect the tape-drive indicative of hardware failure while on-the-shelf ?

Any suggestions welcome ...

Regards,

Howard Thomson

--
"Only two things are infinite, the universe and human stupidity,
and I'm not sure about the former." -- Albert Einstein 

