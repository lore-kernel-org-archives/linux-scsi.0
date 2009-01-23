From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [dm-devel] RE: qla2xxx 0000:03:0c.0: Firmware image unavailable
Date: Thu, 22 Jan 2009 17:15:36 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF45CEAB8A3@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF45CEAB550@cosmail01.lsi.com>
	<D4B83214B57CAC4499F1114D069E451A01A7D6FA@bunker.inside.abhaisystems.com>
	<E463DF2B2E584B4A82673F53D62C2EF45CEAB586@cosmail01.lsi.com>
 <20090122164616.GF19147@sanger.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og113.obsmtp.com ([64.18.2.179]:35259 "EHLO
	exprod7og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbZAWAPs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 19:15:48 -0500
In-Reply-To: <20090122164616.GF19147@sanger.ac.uk>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


Yes, firmware images are in the initrd. I have verified that. 

Thanks
Babu Moger 

-----Original Message-----
From: dm-devel-bounces@redhat.com [mailto:dm-devel-bounces@redhat.com] On Behalf Of Dave Holland
Sent: Thursday, January 22, 2009 10:46 AM
To: device-mapper development
Cc: linux-scsi@vger.kernel.org
Subject: Re: [dm-devel] RE: qla2xxx 0000:03:0c.0: Firmware image unavailable

On Thu, Jan 22, 2009 at 08:20:48AM -0700, Moger, Babu wrote:
> You are right. Looks like qlogic driver loads even before udev hotplug
> is functional.  Driver loads successfully when I re-load the driver
> after the system in up.  Is there any solution or work-around for this
> problem?

So the problem only happens at boot time? Are you using an initrd, and
if so, have you got the firmware images in the initrd image?
(mkinitramfs, update-initramfs, etc)

Dave
-- 
** Dave Holland ** Systems Support -- Infrastructure Management **
** 01223 496923 ** The Sanger Institute, Hinxton, Cambridge, UK **
"Your bumper is my crumple zone."


-- 
 The Wellcome Trust Sanger Institute is operated by Genome Research 
 Limited, a charity registered in England with number 1021457 and a 
 company registered in England with number 2742969, whose registered 
 office is 215 Euston Road, London, NW1 2BE. 

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
