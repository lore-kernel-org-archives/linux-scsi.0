From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Mon, 01 Oct 2012 00:57:48 -0400
Message-ID: <506922CC.1030002@pobox.com>
References: <Pine.LNX.4.44L0.1209301533280.18360-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1209301533280.18360-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Aaron Lu <aaron.lu@intel.com>, Oliver Neukum <oneukum@suse.de>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/30/2012 03:43 PM, Alan Stern wrote:
> On Sun, 30 Sep 2012, Jeff Garzik wrote:
>
>> The simple fact of "only ZPODD devices out there are ATA" is not the
>> decision-maker for where the code should live.  It is more a question
>> where ZPODD belongs in the device/command set model currently employed.
>
> I don't really accept this argument.  It's a little like saying: The
> tty layer uses ioctl commands to control RS232 line settings; therefore
> RS232 settings should be handled in the VFS layer as part of the ioctl
> core.

Hardly -- sr is an optical device driver, much more aligned.

And libata is probably at least 50% of the entire sr userbase, if not 
much much more.

	Jeff




