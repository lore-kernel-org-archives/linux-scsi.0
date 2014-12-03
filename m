From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] mpt{2,3}sas remove disconnected phys on topology
 change
Date: Wed, 3 Dec 2014 01:28:21 -0800
Message-ID: <20141203092821.GA14517@infradead.org>
References: <1375351291-27107-1-git-send-email-jvesely@redhat.com>
 <57e91c7f7bc1d3e0cd511f828ec8140b@mail.gmail.com>
 <547DC792.6070506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <547DC792.6070506@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Jan Vesely <jvesely@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Dec 02, 2014 at 03:07:14PM +0100, Tomas Henzl wrote:
> Hi Sreekanth,
> 
> I think this should be handled as any other change with an usual
> patch sent to the list, 'git revert 3520f9c779' and 'git revert 963ba22b90'
> will create the patches for you.

Exactly.  And now I'll need a review for them..
