From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device
 structure
Date: Wed, 15 Jun 2011 10:43:25 -0400
Message-ID: <1308149005.2616.10.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
	 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-06-15 at 17:16 +0900, Nao Nishijima wrote:
> Allow users to set the preferred name of device via sysfs interface.
> 
> (Exsample) sda -> foo
> # echo foo > /sys/block/sda/preferred_name
> 
> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>

So, as I said previously, I think this needs to be in struct device not
struct gendisk.   It will be an easier infrastructure to use and it
easily generalises to our other naming problems (like net).

James
