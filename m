From: Philippe Pegon <Philippe.Pegon@crc.u-strasbg.fr>
Subject: Re: [PATCH 1/3] cciss: bug fix for hpacucli
Date: Fri, 18 Nov 2005 22:45:28 +0100
Message-ID: <437E4B78.80908@crc.u-strasbg.fr>
References: <20051118163357.GA10928@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161260AbVKRVtG@vger.kernel.org>
In-Reply-To: <20051118163357.GA10928@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: mikem <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@osdl.org, axboe@suse.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hpa@zytor.com, sitniko@infonet.ee
List-Id: linux-scsi@vger.kernel.org

mikem wrote:
> Patch 1 of 3
> 
> This patch fixes a bug that breaks hpacucli, a command line interface
> for the HP Array Config Utility. Without this fix the utility will
> not detect any controllers in the system. I thought I had already fixed
> this, but I guess not.
> 
> Thanks to all who reported the issue. Please consider this this inclusion.

reply too fast ;)
thanks you a lot for that one

--
Philippe Pegon
