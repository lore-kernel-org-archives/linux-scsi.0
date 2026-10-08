Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1250C3BB694
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 07:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791443387; cv=none; b=AsWwz6hSUa3ifIc8+aMqZlmXw+9ebSO2qsiCH3BM3v8MXBOwx7rNPRFUQ68+2bnn4i4Vw1Oq0n8nRfXs/yGbAxaM74TF63GhociI1BX2BuYSTe7PcHbZr9t7SqHOjRj3mHX+Kp+pr66lGzQUTLRK539FahzxCW/0Q4SrotvyOfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791443387; c=relaxed/simple;
	bh=GdMgd4wcu7s1uEPC4fYzrkCi3fIP9ZdwfX8/G8nQWCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=owN9xu7j+kmpb1xM8GOuHjfSqiXCTaIv3IvOqaGbJzCJOitpYqMQybQ/5dxugNIkyHvAOX+chboN31VBDVKfLGJqocZmtH2XNnl3yESY65AsNTvN3QU6cU8CwAWzYIlTSgZSHBfl64wZQvf6hviPlFgeyGb3uFiD29fsmvh8Ylc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70C6768BEB; Thu,  8 Oct 2026 09:09:40 +0200 (CEST)
Date: Thu, 8 Oct 2026 09:09:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH v4 5/8] scsi: scsi_debug: Split resp_write_dt0()
Message-ID: <20261008070940.GA30898@lst.de>
References: <cover.1791349129.git.bvanassche@acm.org> <cd2d03eef52045b8a94c7c11644c3676f91b105f.1791349129.git.bvanassche@acm.org> <20261007131218.GC30647@lst.de> <2dbc5f92-10b1-4265-b08f-86b7c49b85b7@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dbc5f92-10b1-4265-b08f-86b7c49b85b7@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 07, 2026 at 01:08:52PM -0700, Bart Van Assche wrote:
> On 10/7/26 6:12 AM, Christoph Hellwig wrote:
>> On Tue, Oct 06, 2026 at 10:07:27PM -0700, Bart Van Assche wrote:
>>> + * Returns 0 upon success or -1 with *scsi_status set to a SCSI status code upon
>>
>> Overly long line.
>
> Hi Christoph,
>
> This line should be exactly 80 columns wide. Is that too wide? I'm fine 
> with reformatting this comment but I'm surprised to read that 80 columns
> is too wide?

It's fine, sorry.

