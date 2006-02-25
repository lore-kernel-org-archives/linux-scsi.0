From: "Christiaan den Besten" <chris@scorpion.nl>
Subject: Re: [PATCH] sata_promise: Port enumeration order - SATA 150 TX4, SATA 300 TX4
Date: Sat, 25 Feb 2006 11:52:21 +0100
Message-ID: <011f01c639f9$8dc86bc0$3d64880a@speedy>
References: <43FFAE3D.7010002@physics.harvard.edu> <44000036.7070403@eyal.emu.id.au>
Reply-To: "Christiaan den Besten" <chris@scorpion.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, Milan Kupcevic <milan@physics.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@rustcorp.com.au, torvalds@osdl.org
List-Id: linux-scsi@vger.kernel.org

Hi !

We have several of these boards in use [SATA 300 TX4] (bought over time .. not in one batch). All of them have the ordering as 
described below. So another vote for "Please fix!" :)

bye,
Chris

----- Original Message ----- 
From: "Eyal Lebedinsky" <eyal@eyal.emu.id.au>
To: "Milan Kupcevic" <milan@physics.harvard.edu>
Cc: "Jeff Garzik" <jgarzik@pobox.com>; <linux-ide@vger.kernel.org>; <linux-scsi@vger.kernel.org>; <linux-kernel@vger.kernel.org>; 
<trivial@rustcorp.com.au>; <torvalds@osdl.org>
Sent: Saturday, February 25, 2006 7:59 AM
Subject: Re: [PATCH] sata_promise: Port enumeration order - SATA 150 TX4, SATA 300 TX4


> Milan Kupcevic wrote:
>> From: Milan Kupcevic <milan@physics.harvard.edu>
>>
>> Fix Promise SATAII 150 TX4 (PDC40518) and Promise SATA 300 TX4
>> (PDC40718-GP) wrong port enumeration order that makes it (nearly)
>> impossible to deal with boot problems using two or more drives.
>>
>> Signed-off-by: Milan Kupcevic <milan@physics.harvard.edu>
>> ---
>>
>> The current kernel driver assumes:
>>
>> port 1 - scsi3
>> port 2 - scsi1
>> port 3 - scsi0
>> port 4 - scsi2
>
> I totally agree with the fact that the Linux driver gets the ports wrong
> when compared to the BIOS, Windows and surely contradicts the port
> numbers printed on the board. I doubt we all got samples on the one
> bad batch...
>
> It *is* a real problem and if the solution is correct then I support it.
>
> Maybe we need a quick feedback from current users: do you guys find
> that the ports are detected as they are labelled (white silk screen)
> on the board or do they show up out of order (as listed above by
> Milan)?
>
> -- 
> Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
> attach .zip as .dat
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> 

