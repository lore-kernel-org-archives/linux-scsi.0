From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 0/3] target/iscsi networkportal race fixes
Date: Tue, 28 Jan 2014 12:04:51 -0800
Message-ID: <52E80D63.6030208@redhat.com>
References: <1390609136-28674-1-git-send-email-agrover@redhat.com> <1390936535.20018.3.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1390936535.20018.3.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/28/2014 11:15 AM, Nicholas A. Bellinger wrote:
> Hi Andy,
> 
> On Fri, 2014-01-24 at 16:18 -0800, Andy Grover wrote:
>> see https://bugzilla.redhat.com/show_bug.cgi?id=1055064
>>
>> Summary: if thread doesn't run before 2nd identical portal is created,
>> it misses the existing one and the kernel_bind returns an error.

> Applied, squashed into a single bugfix patch, and adding a CC'ed to
> stable.
> 
> FYI, on patch #3, there where a few exception path mutex_unlocks
> missing, so the following incremental has been applied + squashed as
> well.

Thanks for the review and fixes! -- Andy
