Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB0D18041;
	Wed, 24 Jan 2024 09:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706087329; cv=none; b=lvxmiKKAgKIqF04onhJkMDLdoJX2j+QNUDlKM4G5GB8283uQ0xXMV/eve4FPmngof9p7Sd+yXMxcgideZ//lZ3RM6cBvENhG/F9pC0cQu20YBFm++BygAOvlPBoRc6C80eEAe5aaj8eolfFqQH+1eTTz5WefJjARzsXd/yRxrgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706087329; c=relaxed/simple;
	bh=w5UCAUqN3folz54n4uOyTlF23BFB53LgwYm/8ZXIsAA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=txiEtcB8Mm0Qs4ldlKfHA7qxzX2jw4456IhAxFsNnFsftNqR2Xip+RjM5rox0y5SQb8HD+R4++OZ7rAPrie/zCX4aPN8cqeBkjX6C6WRP/CcsUwnmOTVSMlQP9pWNOSseBxpCcgAaZxpQr6fw6PxyP3iB75+pstHPVPrgfO1Yqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B5E5D68BFE; Wed, 24 Jan 2024 10:08:43 +0100 (CET)
Date: Wed, 24 Jan 2024 10:08:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>, Keith Busch <kbusch@kernel.org>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Ed Tsai <ed.tsai@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v6 1/4] block: Make fair tag sharing configurable
Message-ID: <20240124090843.GA28180@lst.de>
References: <2d83fcb3-06e6-4a7c-9bd7-b8018208b72f@huaweicloud.com> <20240115055940.GA745@lst.de> <0d23e3d3-1d7a-f76b-307b-7d74b3f91e05@huaweicloud.com> <f1cac818-8fc8-4f24-b445-d10aa99c04ba@acm.org> <e0305a2c-20c1-7e0f-d25d-003d7a72355f@huaweicloud.com> <aedc82bc-ef10-4bc6-b76c-bf239f48450f@acm.org> <20240118073151.GA21386@lst.de> <434b771a-7873-4c53-9faa-c5dbc4296495@acm.org> <20240123091316.GA32130@lst.de> <ac240189-d889-448b-b5f7-7d5a13d4316d@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac240189-d889-448b-b5f7-7d5a13d4316d@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 23, 2024 at 07:16:05AM -0800, Bart Van Assche wrote:
> On 1/23/24 01:13, Christoph Hellwig wrote:
>> The point is why you think fair sharing is not actually required for
>> these particular setups only.
>
> Hi Christoph,
>
> Do you perhaps want me to move the SCSI host sysfs attribute that controls
> fair sharing to the /sys/block/${bdev}/queue directory?

No.  I want an explanation from you why you think your use case is so
snowflake special that you and just you need to fisable fair sharing.

