From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: GFP_ATOMIC allocations...
Date: 29 Aug 2002 17:50:37 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1030639837.7171.145.camel@irongate.swansea.linux.org.uk>
References: <OF9C38FD78.07E54601-ON87256C24.0056B509@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <OF9C38FD78.07E54601-ON87256C24.0056B509@boulder.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org, patman@beaverton.ibm.com

On Thu, 2002-08-29 at 16:59, Bryan Henderson wrote:
> That (the NULL case) doesn't sound right to me.  The purpose of the OOM
> Killer is to choose wisely which processes should die when there's simply
> not enough memory to go around. 

It can return NULL in such cases. It shouldn't in the current case ever
do this for an allocation exceeding 4K unless you are in an I/O path.
However its a good idea to program for the can always happen case

