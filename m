From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH v1] ibmvscsis: Use tpgt passed in by user
Date: Thu, 08 Jun 2017 22:54:45 -0700
Message-ID: <1496987685.28997.35.camel@haakon3.risingtidesystems.com>
References: <1496781949-46587-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1496781949-46587-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: mchristi@redhat.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-06-06 at 15:45 -0500, Bryant G. Ly wrote:
> ibmvscsis always returned 0 for the tpg/tag, since it did not
> parse the value passed in by the user.
> 
> When functions like ALUA members exports the value, it will
> be incorrect because targetcli/rtslib starts the tpg numbering
> at 1.
> 
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Applied to target-pending/for-next.

Thanks Bryant + MNC.
