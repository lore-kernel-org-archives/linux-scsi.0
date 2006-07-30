From: Steve McIntyre <steve@einval.com>
Subject: Re: cd burning with plextor drives.
Date: Sun, 30 Jul 2006 12:09:45 +0100
Message-ID: <E1G79B3-0005aH-7P@sledge.mossbank.org.uk>
References: <20060729045249.GA23398@redhat.com> <20060729111240.GG13095@suse.de> <Pine.LNX.4.64.0607290953220.4168@g5.osdl.org> <20060729172205.GG16946@redhat.com> <20060729172205.GG16946@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lump.einval.com ([217.147.81.17]:10768 "EHLO mail.einval.com")
	by vger.kernel.org with ESMTP id S932265AbWG3LJq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Jul 2006 07:09:46 -0400
Received: from sledge.mossbank.org.uk ([10.13.0.5] ident=Debian-exim)
	by mail.einval.com with esmtp (Exim 3.36 #1 (Debian))
	id 1G79B3-0000Y5-00
	for <linux-scsi@vger.kernel.org>; Sun, 30 Jul 2006 12:09:45 +0100
Received: from steve by sledge.mossbank.org.uk with local (Exim 4.50)
	id 1G79B3-0005aH-7P
	for linux-scsi@vger.kernel.org; Sun, 30 Jul 2006 12:09:45 +0100
In-Reply-To: <20060730102115.GD8910@bitwizard.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Rogier Wolff writes:
>On Sat, Jul 29, 2006 at 01:22:05PM -0400, Dave Jones wrote:
>> I had visions of extending verify_command() to be of the form..
>> 
>> 	if (devicevendor==PLEXTOR) {
>> 		safe_for_write(ENABLE_BURN_PROOF);
>> 		safe_for_write(ENABLE_FROBNICATOR);
>> 	}
>> 	etc..
>
>Almost there.... 
>
>Instead it should walk a (device-specific (*)) table, that specifies
>what is "safe". The table has masks to specify which bits are
>important and what values are expected and allowed etc etc.
>
>This table could be initialized "empty". 
>
>Next a simple interface should allow root to modify the table. 

Yup. I proposed a proof-of-concept patch to allow this a while back -
let root define policy per-device:

http://marc.theaimsgroup.com/?l=linux-scsi&m=113214433405637&w=2

-- 
Steve McIntyre, Cambridge, UK.                                steve@einval.com
Into the distance, a ribbon of black
Stretched to the point of no turning back
