From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 5.2+ merge window
Date: Tue, 09 Jul 2019 12:43:26 -0700
Message-ID: <1562701406.3362.105.camel@HansenPartnership.com>
References: <1562699693.3362.93.camel@HansenPartnership.com>
         <yq1lfx7c80r.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1lfx7c80r.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2019-07-09 at 15:39 -0400, Martin K. Petersen wrote:
> James,
> 
> > This is mostly update of the usual drivers: qla2xxx, hpsa, lpfc,
> > ufs, mpt3sas, ibmvscsi, megaraid_sas, bnx2fc and hisi_sas as well
> > as the removal of the osst driver (I heard from Willem privately
> > that he would like the driver removed because all his test hardware
> > has failed).  Plus number of minor changes, spelling fixes and
> > other trivia.
> 
> Looks like you forgot to pull in the scatterlist topic branch.

Actually, I was planning a second pull request for that one.  I presume
you think it's ready to go?

James
