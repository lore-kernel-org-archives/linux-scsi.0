From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/2] virtio_scsi: Implement fc_host
Date: Mon, 16 Jan 2017 17:45:35 +0100
Message-ID: <95f96b48-aa75-0094-a634-db9c13035336@redhat.com>
References: <20170116160430.11815-1-famz@redhat.com>
	<20170116160430.11815-3-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20170116160430.11815-3-famz@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Fam Zheng <famz@redhat.com>, linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "Michael S. Tsirkin" <mst@redhat.com>, virtualization@lists.linux-foundation.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org



On 16/01/2017 17:04, Fam Zheng wrote:
> +		node_name = virtio_cread64(vdev,
> +			offsetof(struct virtio_scsi_config, primary_wwnn));
> +		port_name = virtio_cread64(vdev,
> +			offsetof(struct virtio_scsi_config, primary_wwpn));
> +	} else {
> +		node_name = virtio_cread64(vdev,
> +			offsetof(struct virtio_scsi_config, secondary_wwnn));
> +		port_name = virtio_cread64(vdev,
> +			offsetof(struct virtio_scsi_config, secondary_wwpn));

Is the endianness correct for big-endian host here?

Thanks,

Paolo
