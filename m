From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH RFC 3/3] btrfs: add .copy_file_range file operation
Date: Tue, 14 Apr 2015 13:08:02 -0400
Message-ID: <552D4972.9010509@fb.com>
References: <1428703236-24735-1-git-send-email-zab@redhat.com> <1428703236-24735-4-git-send-email-zab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428703236-24735-4-git-send-email-zab@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zach Brown <zab@redhat.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-nfs@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/10/2015 06:00 PM, Zach Brown wrote:
> This rearranges the existing COPY_RANGE ioctl implementation so that the
> .copy_file_range file operation can call the core loop that copies file
> data extent items.
> 
> The extent copying loop is lifted up into its own function.  It retains
> the core btrfs error checks that should be shared.
> 

Thanks Zach, the btrfs bits look reasonable

Signed-off-by: Chris Mason <clm@fb.com>

-chris
