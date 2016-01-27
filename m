From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] LIO/SCST Merger
Date: Wed, 27 Jan 2016 10:08:24 -0800
Message-ID: <1453918104.2322.26.camel@HansenPartnership.com>
References: <56A9043B.7030207@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56A9043B.7030207@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-01-27 at 09:54 -0800, Bart Van Assche wrote:
> Last year, during the 2015 LSF/MM summit, it has been decided that 
> the LIO/SCST merger project should proceed by sending the 
> functionality upstream that is present in SCST but not yet in LIO. 
> This will help to reduce the workload of target driver maintainers 
> that maintain a version of their target driver for both LIO and SCST 
> (QLogic FC and FCoE target drivers, Emulex FC and FCoE target 
> drivers, RDMA iSER target driver, RDMA SRP target driver, ...). My 
> proposal is to organize a session during which the following is
> discussed:
> * Which patches are already upstream in the context of the LIO/SCST 
> merger project.
> * About which patches there is agreement but that are not yet
> upstream.
> * To discuss how to proceed from here and what to address first.

Can you begin this in email ... I don't think any of us are clear if
there's still an issue here ... or that we'd say more than send the
patches upstream, like we did last year.  Just reporting on patch
status isn't that useful ... if there were design disputes or issues to
discuss that caused the patches not to be accepted, that would be more
useful.

James
