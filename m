From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v5] SCSI host lock push-down
Date: Tue, 16 Nov 2010 02:31:33 -0500
Message-ID: <4CE23355.6090205@garzik.org>
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com> <20101113051635.GA11613@havoc.gtf.org> <20101116071029.GA13540@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101116071029.GA13540@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/16/2010 02:10 AM, Jeff Garzik wrote:
> and remove one parameter from queuecommand,
> 	void (*done)(struct scsi_cmnd *)

add appropriate credit to James (and willy?) for this bit...
