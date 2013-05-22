From: Or Gerlitz <or.gerlitz@gmail.com>
Subject: Re: [GIT PULL] target fixes for v3.10-rc2
Date: Wed, 22 May 2013 23:38:32 +0300
Message-ID: <CAJZOPZLkizPeFPjVzsBjwYZ3ARWgVciSgaexmyJHNAN7KAe1Og@mail.gmail.com>
References: <1368654607.6899.16.camel@haakon3.risingtidesystems.com>
	<CAJZOPZK7_VPzcJnc1s9oZVshvGMbm-LDVO-ZoKu63tD1bqcvDg@mail.gmail.com>
	<1368680029.15002.32.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1368680029.15002.32.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, shlomop@mellanox.com
List-Id: linux-scsi@vger.kernel.org

On Thu, May 16, 2013 at 7:53 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:

> Yes, that's the patch included in the PULL request here:
> http://git.kernel.org/cgit/linux/kernel/git/nab/target-pending.git/commit/?h=queue&id=52c07423a819091b0fe9abbf26977098b996f85b

Cool!

>
> Btw, It still needs to be enabled in userspace, but appending a
> rd_nullio=1 to the /control parameters with the following lio-utils
> patch should work for your testing purposes atm..

are you merging this into the lio-utils git tree and maybe sparing a
word on that in the documentation (where?) we'd like to point people
to these bits and guidelines.

Or.
