Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795197103;
	b=DmNYkJBJajCcWqsWgRHPm4oy9i/iKHbBYjQw5pgYM7J6lH7DxGv1th9gcxUCe0n0tvJN
	 V2MlilkzbrutzNQ7gGX8movCpKFEVd8AP955gk0OqZiVJV1V0MWya7Ygs9hxI5VH4s4lJ
	 H5UqbUlHF49m23r2J1tVRcO4rpr1gkidM+QCLNsmAyTK50nX6ZocpihFFXYZTUbixDieb
	 HDRNxzCkflo4rttgd/WZj4iVcURvPHipnxihT6w42QTusSQjgYQ+EJ7JvgexYx7AZdq5B
	 jiAl90fE20of6zsjoOv2APYQkg4x95XWLqgoD9dVlkUwwvM68D6DAi0hgDicPy1RjDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795197103;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:Organization:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=qceHL0HNpAVAm3UFmrfYwVSFpskL9TvZqX3Z7/QsQ1c=;
	b=FCxijvUbnfRI6X6n0MsR/G/35caz/vYMMVQQQoVYT4qjbjrjAZYvLpKIx+2XT2scF5oW
	 6hSveTH+2rlJmlBH7gqHHXsCvfV+4gG8a/6jre1NB9A12nKmK75WL2rYnTlRDLt1DWdEj
	 xTuDjbWMuFYUK8akES3h/2xgHTX0JAGDyLaB4tIszYQo3C0pDHztgJ2NpEeCB8UB2ge4N
	 gta2IKkFRGWIxlIqPMjkDrzmnnoUVW1IHv8dGCQlMdIUDpEux/tXjihmfEivJVJ2OiWrS
	 JKKCrxcXAeaaBa2PI9Cl3BnBXOvvHHEjrcpPZ8n8QhbMuozpe5oOQUdRzpYbS+cb4YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kUo5OXbN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06947606A320;
	Fri, 20 Nov 2026 17:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kUo5OXbN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 697E61F000D4;
	Fri, 20 Nov 2026 17:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795197102;
	bh=qceHL0HNpAVAm3UFmrfYwVSFpskL9TvZqX3Z7/QsQ1c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kUo5OXbNdR7+ntXnHLc/cAftML9hPOvxMXZC+tAKm5djfmw/8WsZWvh/0YhDekZlu
	 8XOwW5kBS6fH1QuJelGzpHSqybzVF+6/4hJKdODxg/LUZHFekOHgqrQJIeXQzgb5kz
	 C9onV38Q20s8dTkXnA40eq3Yx9yQW0TOR1Je+4ENPr6KV6Dc3cQW2c0nptdtmVfhLV
	 IaI3gQdoR/YMGPfWzdQs+M3GEFqE2cpI0aNKQIrSUz7F8ivnO87W14u/htb0rJq35M
	 KuCb029lMwnFwof5ZJT99N3vdUTpoDqGKXQ8R2VyxvTSUdyWodtmK8yCUhWYWBBB0y
	 ujOdmn9SZhjIA==
Message-ID: <82e0ce43-73cb-4374-8761-22c178a29f05@kernel.org>
Date: Fri, 20 Nov 2026 09:51:41 -0800
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 08/13] zloop: add storage element emulation
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>
References: <20261116213702.225970-1-dlemoal@kernel.org>
 <20261116213702.225970-9-dlemoal@kernel.org> <20261120152038.GB26913@lst.de>
 <ac126584-6fa3-4cdb-b6c3-ec99f75dafff@kernel.org>
 <20261120173609.GA1206@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20261120173609.GA1206@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/20/26 09:36, Christoph Hellwig wrote:
> On Fri, Nov 20, 2026 at 09:27:15AM -0800, Damien Le Moal wrote:
>> On 11/20/26 07:20, Christoph Hellwig wrote:
>>> I think the Sashiko comment here needs adressing - nothing in the remove
>>> path synchronizes against the raw underlying device access.  Lifting the
>>> stor_elements_lock critical section from zloop_forget_cache to the
>>> caller and making it unconditional should fix that.
>>
>> I do not think that is enough because remove and restore drop the stor lock for
>> the msleep. So this would still be very racy. But adding a disk ref get/put
>> around remove/restore code should solve all issues cleanly as that will prevent
>> the drive being removed while these operations are on-going.
> 
> The disk is already opened and references, that is not the problem.
> The problem is that after del_gendisk, another disk with the same name
> could show up and use the same files.  So we do not some kind of
> synchornization to ensure that del_gendisk doesn't happen while a depop
> is in progress.

Hmmm... That can actually happen regardless of storage elements operations
because we do idr_remove() with zloop_ctl_mutex() being held, but before calling
del_gendisk() without the zloop_ctl_mutex being held. So we do have a race for
the device ID being reused, no?

And taking the storage element mutex will *not* achieve serialization of the
remove & storage element operation because the mutex is released and re-taken by
the remove & restore operations. However, we can simply wait for these
operations by looking at the remove_id and restore_in_progress fields.


-- 
Damien Le Moal
Western Digital Research
