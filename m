From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/2] target: Make target db location configurable
Date: Fri, 01 Apr 2016 09:57:14 +0200
Message-ID: <f21ce41f2b2cafdfafdee8dee42c3e1d@suse.de>
References: <cover.1459278305.git.lduncan@suse.com>
 <553cc68ded2c5fcc51bffa1cf0033a7a9c88144f.1459278305.git.lduncan@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <553cc68ded2c5fcc51bffa1cf0033a7a9c88144f.1459278305.git.lduncan@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@infradead.org, lkml@vger.kernel.org, hare@suse.com, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2016-03-31 20:05, Lee Duncan wrote:
> This commit adds the read-write attribute "dbroot", in
> the top-level CONFIGFS (core) target directory,
> normally /sys/kernel/config/target. This attribute
> defaults to "/var/target" but can be changed by
> writing a new pathname string to it.
> 
> Target modules that care about the target database
> root directory will be modified to use this
> attribute in a future commit.

You forgot to add your Signed-off-by

Otherwise

Reviewed-by: Johannnes Thumshirn <jthumshirn@suse.de>
