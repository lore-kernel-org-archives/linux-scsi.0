From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v4 2/3] usb: storage: add support for write cache quirk
 on
Date: Mon, 11 Jun 2012 10:17:43 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1206111017260.1607-100000@iolanthe.rowland.org>
References: <1339421599-3173-1-git-send-email-linkinjeon@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339421599-3173-1-git-send-email-linkinjeon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net, sshtylyov@mvista.com, bvanassche@acm.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, Pankaj Kumar <pankaj.km@samsung.com>, Amit Sahrawat <a.sahrawat@samsung.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 11 Jun 2012, Namjae Jeon wrote:

> Add support for write cache quirk on usb hdd. scsi driver will be set to wce by detecting write cache quirk in quirk list when plugging usb hdd.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>
