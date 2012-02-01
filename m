From: Andy Grover <agrover@redhat.com>
Subject: Re: FireWire/SBP2 Target mode
Date: Wed, 01 Feb 2012 11:50:34 -0800
Message-ID: <4F29978A.3010707@redhat.com>
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E4D3B88.30003@ladisch.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Chris Boot <bootc@bootc.net>, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Sorry to raise this thread from the dead.

Chris Boot wrote Aug 2011-ish:
> I would very much like to see something like this added to the
> kernel, and would very much like to contribute to writing this
> feature. However my kernel development knowledge is very limited
> indeed so this would require a lot hand-holding and mentoring.

If you're still interested, I'd definitely encourage you to work on this
project. Me and others on target-devel would be happy to help with any
target-related advice.

On 08/18/2011 09:19 AM, Clemens Ladisch wrote:
> Chris Boot wrote:
>> Now that we have a nice SCSI target framework in the kernel, and drivers
>> either in-tree or being worked on for iSCSI, FC, FCoE, SAS and iSER, I
>> was wondering about the possibility of adding FireWire to that list.
> 
> As far as I can tell from briefly looking at the framework, this would
> require both a fabric module (which is nicely abstracted) and a new
> protocol (which doesn't seem to be).
> 
> Is there any documentation of how to add a new LIO protocol?
> 
> And what is the difference between a protocol and a fabric?

Right now the documentation is the other fabric modules, alas.

You're saying the sbp2 protocol can theoretically be used other places
besides firewire? I'd say put it all in the fabric module for now.

You can also join irc.oftc.net #storage and ask more questions there.

Regards -- Andy
