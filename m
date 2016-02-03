From: Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH 0/2] scsi: Fix endless loop of ATA hard resets due to VPD reads
Date: Wed, 3 Feb 2016 07:27:20 -0800
Message-ID: <CAKgT0UcWHgeRXuMDsOCXacwv6OL9T8FBCbqCYR1wu1iQkCmhmQ@mail.gmail.com>
References: <20160121063039.3803.66.stgit@localhost.localdomain>
	<20160202101830.GA3786@node.shutemov.name>
	<yq1fuxamrz7.fsf@sermon.lab.mkp.net>
	<20160203064808.GA10548@node.shutemov.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160203064808.GA10548@node.shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Alexander Duyck <aduyck@mirantis.com>, jbottomley@odin.com, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Shane M. Seymour" <shane.seymour@hpe.com>, jthumshirn@suse.de
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 2, 2016 at 10:48 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On Tue, Feb 02, 2016 at 09:45:48PM -0500, Martin K. Petersen wrote:
>> >>>>> "Kirill" == Kirill A Shutemov <kirill@shutemov.name> writes:
>>
>> Kirill> I have the same problem.
>>
>> Kirill> Shouldn't we put quirk for that?
>>
>> I was hoping that Hannes' patch would do the trick so we could avoid
>> blacklisting:
>>
>>       https://patchwork.kernel.org/patch/8079011/
>
> It didn't help me.

My patch didn't resolve the Marvell issue, it just resolved other
cases that could also lead to the same problem.

I added a line to my kernel parameters to blacklist the Marvell
console.  I wasn't sure if blacklisting would have been acceptable.
That is why I called out that I still had to add that line to my
kernel in the cover letter for my patch set.

- Alex
