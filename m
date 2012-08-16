From: Robert Trace <maillist@farcaster.org>
Subject: Re: 'Device not ready' issue on mpt2sas since 3.1.10
Date: Thu, 16 Aug 2012 14:26:49 -0400
Message-ID: <502D3B69.1090403@farcaster.org>
References: <4FFB8A86.7000009@farcaster.org>  <4FFCBA4C.4000502@farcaster.org> <4FFD6F3D.2030708@matthiasprager.de>  <4FFD8410.7050604@matthiasprager.de> <20120717180932.GB2878@google.com>  <5005BF7D.2050703@matthiasprager.de> <20120717200136.GC24336@google.com>  <500A9D7C.8080801@matthiasprager.de>  <20120722173146.GE5144@dhcp-172-17-108-109.mtv.corp.google.com>  <1343225953.12094.55.camel@dabdike> <20120725171723.GB32378@google.com> <1343246155.12094.59.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1343246155.12094.59.camel@dabdike>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <tj@kernel.org>, Matthias Prager <linux@matthiasprager.de>, linux-scsi@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>, Eric Moore <Eric.Moore@lsi.com>, Alan <alan@lxorguk.ukuu.org.uk>, "Darrick J. Wong" <djwong@us.ibm.com>, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/25/2012 03:55 PM, James Bottomley wrote:
> 
> Well, reading it, so do I.  Unfortunately, we get to deal with the world
> as it is rather than as we would wish it to be.  We likely have this
> problem with a lot of USB SATLs as well ...

Has this patch made it into the main git trees yet?

I haven't seen anything about it in nearly a month, but I've been using
the James' patch since he posted it and the sleep/wakeup behavior seems
improved/correct.

-- Robert
