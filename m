From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH V3] bio: modify __bio_add_page() to accept pages that
 don't start a new segment
Date: Tue, 27 May 2014 18:15:45 +0800
Message-ID: <CACVXFVNSZ7+MxW8-SiLXUFW6pGJ7b-OQzf8-KLzcXyE7BvhbbA@mail.gmail.com>
References: <1398952615-22034-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1398952615-22034-1-git-send-email-mlombard@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Linux SCSI List <linux-scsi@vger.kernel.org>, Kent Overstreet <kmo@daterainc.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, m.lombardi85@gmail.com
List-Id: linux-scsi@vger.kernel.org

Hi Maurizio,

On Thu, May 1, 2014 at 9:56 PM, Maurizio Lombardi <mlombard@redhat.com> wrote:
> The original behaviour is to refuse to add a new page if the maximum number
> of segments has been reached, regardless of the fact the page we are
> going to add can be merged into the last segment or not.

If the page can be merged to last segment, it should have been
covered by code in branch of 'if (bio->bi_vcnt > 0) ...', shouldn't it?

Or maybe it is better to make that code cover your case since
looks your case is similar with that one according to your commit
log.


Thanks,
-- 
Ming Lei
