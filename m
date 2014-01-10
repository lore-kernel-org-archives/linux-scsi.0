From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device
 attributes
Date: Thu, 09 Jan 2014 23:00:38 -0800
Message-ID: <1389337238.5567.408.camel@haakon3.risingtidesystems.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
	 <1389212157-14540-10-git-send-email-nab@daterainc.com>
	 <52CE817B.9070203@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <52CE817B.9070203@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-01-09 at 13:01 +0200, Sagi Grimberg wrote:
> On 1/8/2014 10:36 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch adds support for exposing DIF protection device
> > attributes via configfs.  This includes:
> >
> >     pi_prot_type: Protection Type (0, 1, 3 currently support)
> >     pi_prot_version: Protection Version (DIF v1 currently supported)
> >     pi_guard_type: Guard Type (1=DIF CRC, 2=IP CRC)
> >
> > Within se_dev_set_pi_prot_type() it also adds the se_subsystem_api
> > device callbacks to setup per device protection information.
> 
> Suggestion, expose pi_prot_format and call transport->init_prot() there. 
> It is more explicit
> and this routine should be called upon getting FORMAT_UNIT as well.

<nod>, working on this next for FILEIO following your original example
code.

Thanks Sagi!

--nab
