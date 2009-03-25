From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Add a 'wait-scan' command to /proc/scsi/scsi.
Date: Wed, 25 Mar 2009 15:01:37 -0400
Message-ID: <20090325190137.GA8509@infradead.org>
References: <1238007647-25752-1-git-send-email-notting@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1763280AbZCYTBy@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1238007647-25752-1-git-send-email-notting@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bill Nottingham <notting@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 25, 2009 at 03:00:46PM -0400, Bill Nottingham wrote:
> scsi_wait_scan.ko is a bad interface for a variety of reasons:
> - once you load it, it stays in memory doing nothing
> - if you need to call it again, you first need to check for the module
>   and unload it first
> - waiting for scsi scans shouldn't require module loading privleges in
>   any case
> 
> This creates a simpler interface that doesn't require as much
> scaffolding in userspace.

/proc/scsi/scsi is deprecated, plese don't add more features to it.
