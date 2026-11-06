Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793927724;
	b=C5T1m5aezbDbml4JnvkjKWJCdPz50v/MMK4kqIhlY4qgTvHlelLJ+Ujsn4XKR1tcpw0X
	 pkLCwMCh1eOnoF5Wr1PJCQVuxY59rTQxdMapmEAyx+w3EWPA/G8SoovudFHH86r7mSa2R
	 QUMH0FjHXZBEWbpRaizMcsDTcKJnCgKVWKwJ55mdvlBgIKwPfA9i4RJX2/0aVmXCPW1Hk
	 O1HJ/M1+w9KU7Bdav6TlvwGSVMLWEX6JceBd3xoIWsun8TOfjjHJE+fUm2y6FCsn3Onqx
	 /O5CzDOFwCOsvylFvZpFrwHKJ/Ul8H9WQ6QxyVY8KM4KbJaOhi2mvMg+2j/CzXnH/JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793927724;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=CT1o7u+CFcHlbgxTFbymWAKOAQgR6++tP4iAUgvJ+2Y=;
	b=PyawVUALRvpMWAsAZqtKwkbAV4bOFC04AKfmltL32lhgdmyN7G12YDLainPimFiz0JvR
	 gEqcxfXUyV+KERYdqtaoTzvNhh9a8DR6hzIIvqR0BDQcrn1QKgVv92KnN3mLmytdzerIX
	 pHxg3Ai7zyFG2b5B9hJZnEtF3Oy2UHbKceWqpId89U2pU5aXNI0OY4+gf5m0kS9EkvEdL
	 rQEfh49BPjozT+4F0aNlyYFQXK0tMLp/S0nnlLLhL8deVVWmhl8z4wmKmnsQLiKp6XH8U
	 TAhWCdT+BivQFardTMOnBw1kbfZ0IuwUssj72zg+SY08awshK5QT1Rd6XPZ7KlL4QDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cbzjRxPV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37D9606A31B
	for <linux-scsi@vger.kernel.org>; Fri,  6 Nov 2026 01:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cbzjRxPV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 238E61F0089F;
	Fri,  6 Nov 2026 01:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793927723;
	bh=CT1o7u+CFcHlbgxTFbymWAKOAQgR6++tP4iAUgvJ+2Y=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=cbzjRxPVAeW31/XhZUCXH4PaWPeoXqhBkpp5gauu03fUZd826clP4bfvqmiucejUO
	 6nnyZCr92+q+7yhq9qdtGKgWwIgnNZEOpkUbU4GmHtz6wyPwFw90MGQ3w9cfaL25Jy
	 uRDk7PWgqiC9xfMmxq3Ptnyz9wSRHxA5548LeepZh9UZJlsS0Yo5m90ZuX8B89BFBW
	 zH27eaLyAQDcAAdiEFhbWiuX0Qj+NfM6QrU+9qOpEJ0y5wDtEbPROvNQfNapnRsSaD
	 dJldt0wQEyxhePHKFlvItFS/DrG55DhcuKoEDzWzmlFKG7n98VDyT4z1f4FDpopt+j
	 DhnoQnnArBFmw==
Message-ID: <sashiko-outbox-200495@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/37] scsi: mpt3sas: Validate RAID configuration page
 length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1793925772-1303-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1793925772-1303-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1793925772-1303-3-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:15:22 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: mpt3sas: u16 truncation of config_page_sz in _config_reque=
st()
--

commit c2be3bad5af4de88c7b5227eeaab81b3e61723ef
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

scsi: mpt3sas: Validate RAID configuration page length

This commit validates that the RAID configuration page length is large enou=
gh
to hold Mpi2RaidConfigurationPage0_t before allocating the buffer, and boun=
ds
the element loop by the number of elements that fit in the allocated buffer.

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas=
/mpt3sas_config.c
> index b0d5ef8936008..75312d43e3862 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_config.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
> @@ -2655,6 +2655,7 @@ mpt3sas_config_get_volume_handle(struct MPT3SAS_ADA=
PTER *ioc, u16 pd_handle,
>  	int config_num;
>  	u16 element_type;
>  	u16 phys_disk_dev_handle;
> +	int max_num_elements;
> =20
>  	*volume_handle =3D 0;
>  	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
> @@ -2672,6 +2673,13 @@ mpt3sas_config_get_volume_handle(struct MPT3SAS_AD=
APTER *ioc, u16 pd_handle,
> =20
>  	mpi_request.Action =3D MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
>  	config_page_sz =3D (le16_to_cpu(mpi_reply.ExtPageLength) * 4);
> +	if (config_page_sz < offsetof(Mpi2RaidConfigurationPage0_t,
> +				      ConfigElement)) {
> +		ioc_err(ioc, "%s: RAID configuration page length (%d) is too small\n",
> +			__func__, config_page_sz);
> +		r =3D -EIO;
> +		goto out;
> +	}
>  	config_page =3D kmalloc(config_page_sz, GFP_KERNEL);
>  	if (!config_page) {
>  		r =3D -1;
> @@ -2692,7 +2700,11 @@ mpt3sas_config_get_volume_handle(struct MPT3SAS_AD=
APTER *ioc, u16 pd_handle,
>  		    MPI2_IOCSTATUS_MASK;
>  		if (ioc_status !=3D MPI2_IOCSTATUS_SUCCESS)
>  			goto out;
> -		for (i =3D 0; i < config_page->NumElements; i++) {
> +		max_num_elements =3D (config_page_sz -
> +		    offsetof(Mpi2RaidConfigurationPage0_t, ConfigElement)) /
> +		    sizeof(config_page->ConfigElement[0]);
> +		for (i =3D 0; i < config_page->NumElements &&
> +		     i < max_num_elements; i++) {

[Severity: Medium]
Can this read uninitialized heap memory from config_page when ExtPageLength=
 is
0x4000 or larger?

In mpt3sas_config_get_volume_handle(), config_page_sz is a 32-bit int compu=
ted
as le16_to_cpu(mpi_reply.ExtPageLength) * 4, which can reach up to 262140.
The new check only enforces a lower bound before calling kmalloc(), which
allocates uninitialized memory.

When mpt3sas_config_get_volume_handle() then calls _config_request(), the
size is truncated to u16 both in the parameter list and in mem.sz:

drivers/scsi/mpt3sas/mpt3sas_config.c:_config_request() {
	...
	static int
	_config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
		*mpi_request, Mpi2ConfigReply_t *mpi_reply, int timeout,
		void *config_page, u16 config_page_sz)
	...
		if (mpi_request->Header.PageLength)
			mem.sz =3D mpi_request->Header.PageLength * 4;
		else
			mem.sz =3D le16_to_cpu(mpi_reply->ExtPageLength) * 4;
}

Inside _config_request(), only (u16)config_page_sz bytes of config_page are
zeroed with memset() and populated with memcpy().

If ExtPageLength is between 0x4000 and 0x400b, (u16)config_page_sz wraps to
between 0 and 44 bytes, so _config_request() never initializes
config_page->NumElements, config_page->ConfigElement[], or (when wrapped to
11 bytes or less) config_page->ConfigNum. Even for larger values where
ExtPageLength >=3D 0x400c, max_num_elements is computed from the untruncated
32-bit config_page_sz, allowing the loop to read ConfigElement[i] entries
beyond the (u16)config_page_sz bytes actually populated by _config_request(=
).

Also, because _config_request() overwrites mpi_reply on each iteration of t=
he
while (1) loop and recomputes mem.sz from the new mpi_reply.ExtPageLength on
the next pass, a smaller ExtPageLength on a subsequent iteration would copy
fewer bytes than the initial config_page_sz used for max_num_elements.

Should mpt3sas_config_get_volume_handle() also reject config_page_sz > U16_=
MAX
(or allocate with kzalloc()) so that config_page_sz cannot truncate when
passed to _config_request()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1793925772-1303-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D2
