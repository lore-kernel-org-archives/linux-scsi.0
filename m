From: Shanker Balan <shanu@exocore.com>
Subject: Re: Seagate Cheetah: Firmware, Bugs, Compatibility?
Date: Thu, 16 Jan 2003 11:02:10 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030116053210.GB817@exocore.com>
References: <A5974D8E5F98D511BB910002A50A66470580D4F1@hdsmsx103.hd.intel.com> <Pine.LNX.4.44.0301072238580.3021-100000@uplift.swm.pp.se> <20030108081513.GA1217@exocore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030108081513.GA1217@exocore.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI <linux-scsi@vger.kernel.org>

Hello:

Shanker Balan wrote,
> I am having problems flashing the drive. I get an "-2" error with
> sgdskfl.
> 
> Error -2 is a "-2 means that the SCSI request returned a check condition
> (sense error)" from the UserGuide.

Ok, I tracked down the problem - the firmware image was corrupted! :-D

-- Shanu
http://shankerbalan.com/

-- 
Coincidence, n.:
	You weren't paying attention to the other half of what was
going on.
