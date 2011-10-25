From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] target: Updates for v3.2-rc1 (round one)
Date: Tue, 25 Oct 2011 11:45:43 +0200
Message-ID: <CA+55aFyBgZoaN2di1iE4fyMh0r1rECG3stgiqGtiGY4SY7nBmw@mail.gmail.com>
References: <1319533236.17450.338.camel@haakon2.linux-iscsi.org>
 <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com> <20111025094232.GA17763@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20111025094232.GA17763@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 25, 2011 at 11:42 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Tue, Oct 25, 2011 at 11:29:39AM +0200, Linus Torvalds wrote:
>> On Tue, Oct 25, 2011 at 11:00 AM, Nicholas A. Bellinger
>> <nab@linux-iscsi.org> wrote:
>> >
>> > ?36 files changed, 937 insertions(+), 2068 deletions(-)
>>
>> Hmm. This is not what I get. It might be a git version issue or diff
>> algorithm one - although that's actually pretty unusual. Do you do
>> something odd/special?
>
> It's mostly me looking at the code and factoring code and removing
> unneeded things from old versions.

No, I'm saying that the diffstat doesn't match what I get when I pull.

I get

 36 files changed, 955 insertions(+), 2086 deletions(-)

which is *close*, but not identical. I'm wondering where the numbers
Nicholas has came from..

             Linus
