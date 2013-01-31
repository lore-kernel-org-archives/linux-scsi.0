From: "dbasehore ." <dbasehore@chromium.org>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
Date: Thu, 31 Jan 2013 14:02:07 -0800
Message-ID: <CAGAzgsoa4XRsVz8UKVm-qZKmWNq+vsge-BBZewzmrRHSQm0k=A@mail.gmail.com>
References: <1356064540-17414-1-git-send-email-dbasehore@chromium.org>
	<1356263388.15812.7.camel@dabdike.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1356263388.15812.7.camel@dabdike.home>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

(Resending message as plain text so it's tracked through vger lists)

I didn't notice the other call to async_synchronize_full, I'll remove that one.

I split up the functionality of sd_start_stop_device to ensure that
the command to start the disk was sent before resume was completed.
For now, it's open coded, but that could be changed if I make
additions are made to scsi_lib.c to allow us to return immediately
after scheduling the command.
