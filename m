From: Andries.Brouwer@cwi.nl
Subject: Re: [PATCH] scsi/hosts.c device_register fix
Date: Thu, 28 Nov 2002 18:18:15 +0100 (MET)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <UTC200211281718.gASHIFE04317.aeb@smtp.cwi.nl>
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Andries.Brouwer@cwi.nl, James.Bottomley@steeleye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, torvalds@transmeta.com
List-Id: linux-scsi@vger.kernel.org

	From James.Bottomley@steeleye.com  Thu Nov 28 17:57:52 2002

	Actually, the patch is wrong.
	The device_register has to be done in scsi_add_host,
	The correct fix is to move the corresponding device_unregister
	into scsi_remove_host so that they match.

Very good. That was what I had done first, but a google search
turned up your patch and I thought that it was also OK.

	I'll also commit it to the scsi-misc-2.5 BK tree.

Hope to see it in 2.5.51.

Andries
