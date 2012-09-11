From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v6 1/7] scsi: sr: support runtime pm for ODD
Date: Tue, 11 Sep 2012 14:35:21 +0200
Message-ID: <13778612.777Jy5uJnq@linux-lqwf.site>
References: <Pine.LNX.4.44L0.1209061437050.1182-100000@iolanthe.rowland.org> <3491742.cmOxhNregO@linux-lqwf.site> <20120911123116.GB20978@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20120911123116.GB20978@mint-spring.sh.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 11 September 2012 20:31:17 Aaron Lu wrote:
> OK, I think I got your meaning.
> 
> For a simpler scenario:
> 1 User application did an ioctl to lock the door of the ODD when there
> is no medium inside(but why? :-);
> 2 The ODD is runtime suspended;
> 3 The ODD is runtime powered off;
> 4 User presses the eject button, and the door is ejected in sr_resume.
> 
> Condition 1 is a must for this to happen, as if there is medium inside,
> the ODD will never be powered off; or if the underlying block device is
> opened by some process, it will not enter runtime suspend state.
> 
> Looks like I need to record if the door is locked in scsi_cd structure
> so that I did not mistakenly eject the door. Does this sound OK?

Yes, that will do.

	Regards
		Oliver

