From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
Date: Fri, 01 Feb 2013 09:26:59 +1100
Message-ID: <1359671219.7527.3.camel@dabdike>
References: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
	 <1356263388.15812.7.camel@dabdike.home>
	 <CAGAzgsoa4XRsVz8UKVm-qZKmWNq+vsge-BBZewzmrRHSQm0k=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGAzgsoa4XRsVz8UKVm-qZKmWNq+vsge-BBZewzmrRHSQm0k=A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "dbasehore ." <dbasehore@chromium.org>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2013-01-31 at 14:02 -0800, dbasehore . wrote:
> (Resending message as plain text so it's tracked through vger lists)

Just FYI ... I don't get messages sent to me personally and the list, so
if it wasn't on vger, I haven't seen it.

> I didn't notice the other call to async_synchronize_full, I'll remove that one.
> 
> I split up the functionality of sd_start_stop_device to ensure that
> the command to start the disk was sent before resume was completed.
> For now, it's open coded, but that could be changed if I make
> additions are made to scsi_lib.c to allow us to return immediately
> after scheduling the command.

That would be better; I'll wait to see the proposed patch.

James
