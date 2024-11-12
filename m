Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E60207A27;
	Tue, 12 Nov 2024 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731430529; cv=none; b=MWwt3LidCWXGgPY2qtrr79KhTjsiNxfXYt+ca6VJn+TeZmnhJt2QC0R9jEGHlCZAigUzqyWuX6GJdTlf7oOeoWjvmnc2MuW4ZhcKmM6+PwygCzGcXt0gS295isdTo3H9iS9ktAxJGxoa+B0yIctnFZoL/Q+Ed1VWPhfg0kUgEbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731430529; c=relaxed/simple;
	bh=oHV8dgGJODRzQnAXfGtHcp8b24tt13yTkYH7gtMa1WE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZruU9H2MgScLBg8FEFLgrsw9V8oGu4+yuCyuCXF4LhJMEF8klw9AW4jqt8DUN/cuBnwzQ79B3rnHyhmOl0HGN6LkC8omzHnR5b74fwnkH/BGSaii+hJsgYSonqXyN8UXRzzqNBu/ZwunC5ZK5wF1isZZGcaRPRqwXJ6U8ej9/JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 56FAE68D0E; Tue, 12 Nov 2024 17:55:22 +0100 (CET)
Date: Tue, 12 Nov 2024 17:55:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: Daniel Wagner <wagi@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Bjorn Helgaas <bhelgaas@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com,
	storagedev@microchip.com, linux-nvme@lists.infradead.org
Subject: Re: [PATCH v3 3/8] virtio: hookup irq_get_affinity callback
Message-ID: <20241112165522.GC20057@lst.de>
References: <20241112-refactor-blk-affinity-helpers-v3-0-573bfca0cbd8@kernel.org> <20241112-refactor-blk-affinity-helpers-v3-3-573bfca0cbd8@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112-refactor-blk-affinity-helpers-v3-3-573bfca0cbd8@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 12, 2024 at 02:26:18PM +0100, Daniel Wagner wrote:
> struct bus_type has a new callback for retrieving the IRQ affinity for a
> device. Hook this callback up for virtio based devices.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

