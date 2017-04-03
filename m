From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] scsi: storvsc: Add support for FC rport.
Date: Mon, 3 Apr 2017 05:17:18 -0700
Message-ID: <20170403121718.GA13130@infradead.org>
References: <1491219195-3692-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1491219195-3692-1-git-send-email-cavery@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Cathy Avery <cavery@redhat.com>
Cc: jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, hch@infradead.org, devel@linuxdriverproject.org, dan.carpenter@oracle.com
List-Id: linux-scsi@vger.kernel.org

>  	if (host->transportt == fc_transport_template) {
> +		struct fc_rport_identifiers ids = {
> +			.roles = FC_PORT_ROLE_FCP_TARGET,
> +		};

I don't think storvsc ever acts as FCP target.
