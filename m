From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] scsi/bfa: use designated initializers
Date: Tue, 3 Jan 2017 15:25:22 -0800
Message-ID: <CAGXu5jJM-B3r7tF2Mdm3HjY_74_Jme=W7=L9-bvRNKM6eN7XJA@mail.gmail.com>
References: <20161217010515.GA140673@beast> <20161221083350.GA30130@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161221083350.GA30130@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 21, 2016 at 12:33 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Dec 16, 2016 at 05:05:15PM -0800, Kees Cook wrote:
>> Prepare to mark sensitive kernel structures for randomization by making
>> sure they're using designated initializers. These were identified during
>> allyesconfig builds of x86, arm, and arm64, with most initializer fixes
>> extracted from grsecurity.
>
> Instead of further bloating the idiotic dispatch table just kill it off
> entirely:

Sounds fine to me! Is this going via your tree?

Thanks!

-Kees

-- 
Kees Cook
Nexus Security
