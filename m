From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] scsi: storvsc: Add support for FC rport.
Date: Mon, 3 Apr 2017 23:53:31 -0700
Message-ID: <20170404065331.GA2626@infradead.org>
References: <1491219195-3692-1-git-send-email-cavery@redhat.com>
 <20170403121718.GA13130@infradead.org>
 <58E24A9A.30200@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <58E24A9A.30200@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Cathy Avery <cavery@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, kys@microsoft.com, haiyangz@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, stephen@networkplumber.org, dan.carpenter@oracle.com, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 03, 2017 at 09:14:02AM -0400, Cathy Avery wrote:
> On 04/03/2017 08:17 AM, Christoph Hellwig wrote:
> > >   	if (host->transportt == fc_transport_template) {
> > > +		struct fc_rport_identifiers ids = {
> > > +			.roles = FC_PORT_ROLE_FCP_TARGET,
> > > +		};
> > I don't think storvsc ever acts as FCP target.
> 
> In order to implement the work around so that the scsi scan works indicating
> FC_PORT_ROLE_FCP_TARGET as a role was necessary due to its test in
> fc_scsi_scan_rport. The idea here is to avoid making any changes to the
> fc_transport driver which was of some concern.

Please add a FC_PORT_ROLE_FCP_DUMMY_INITIATOR role instead.
