Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D1DC5519F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFA7E21D7E
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 16:41:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ObBpXfzn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgKQQkx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 11:40:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725808AbgKQQkx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 11:40:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605631251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PrtrctB9G5pEBnZheqS7Drb5ElIcN9MmGROgGZcsg40=;
        b=ObBpXfznWBzH7WVVgneqirBpNszo0rtMXngfsk8YP3omTrYne/TmhRqme32OhRCNJWiVRo
        DqxtnxKO4TVyZqMqe9uGwTyvMoyPE7oFJ26YpBpCD5T0tvilKHY2/qbHkaIC016jxNkn4z
        OSKN1R5FdWCkmdFFEfpzlr8jitOMOkY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-QV2m57Y7MBm9bV8zp4uIdg-1; Tue, 17 Nov 2020 11:40:48 -0500
X-MC-Unique: QV2m57Y7MBm9bV8zp4uIdg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91A2A80364C;
        Tue, 17 Nov 2020 16:40:47 +0000 (UTC)
Received: from localhost (ovpn-115-113.ams2.redhat.com [10.36.115.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B1A35D9CC;
        Tue, 17 Nov 2020 16:40:43 +0000 (UTC)
Date:   Tue, 17 Nov 2020 16:40:43 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
Message-ID: <20201117164043.GS131917@stefanha-x1.localdomain>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fqIB0bRxfTYxTb/F"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--fqIB0bRxfTYxTb/F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2020 at 05:18:59PM -0600, Mike Christie wrote:
> The following kernel patches were made over Michael's vhost branch:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=3Dvh=
ost
>=20
> and the vhost-scsi bug fix patchset:
>=20
> https://lore.kernel.org/linux-scsi/20201112170008.GB1555653@stefanha-x1.l=
ocaldomain/T/#t
>=20
> And the qemu patch was made over the qemu master branch.
>=20
> vhost-scsi currently supports multiple queues with the num_queues
> setting, but we end up with a setup where the guest's scsi/block
> layer can do a queue per vCPU and the layers below vhost can do
> a queue per CPU. vhost-scsi will then do a num_queue virtqueues,
> but all IO gets set on and completed on a single vhost-scsi thread.
> After 2 - 4 vqs this becomes a bottleneck.
>=20
> This patchset allows us to create a worker thread per IO vq, so we
> can better utilize multiple CPUs with the multiple queues. It
> implments Jason's suggestion to create the initial worker like
> normal, then create the extra workers for IO vqs with the
> VHOST_SET_VRING_ENABLE ioctl command added in this patchset.

How does userspace find out the tids and set their CPU affinity?

What is the meaning of the new VHOST_SET_VRING_ENABLE ioctl? It doesn't
really "enable" or "disable" the vq, requests are processed regardless.

The purpose of the ioctl isn't clear to me because the kernel could
automatically create 1 thread per vq without a new ioctl. On the other
hand, if userspace is supposed to control worker threads then a
different interface would be more powerful:

  struct vhost_vq_worker_info {
      /*
       * The pid of an existing vhost worker that this vq will be
       * assigned to. When pid is 0 the virtqueue is assigned to the
       * default vhost worker. When pid is -1 a new worker thread is
       * created for this virtqueue. When pid is -2 the virtqueue's
       * worker thread is unchanged.
       *
       * If a vhost worker no longer has any virtqueues assigned to it
       * then it will terminate.
       *
       * The pid of the vhost worker is stored to this field when the
       * ioctl completes successfully. Use pid -2 to query the current
       * vhost worker pid.
       */
      __kernel_pid_t pid;  /* in/out */

      /* The virtqueue index*/
      unsigned int vq_idx; /* in */
  };

  ioctl(vhost_fd, VHOST_SET_VQ_WORKER, &info);

Stefan

--fqIB0bRxfTYxTb/F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+z/QoACgkQnKSrs4Gr
c8hlxAgAt5dzFMEBdSdRp7hlgZgQqjlbY0sBm70KpODN/xBzs8Q2v0wdnoQb31pX
hxrxuWMrrEyu0RPvaCbTZNhTnyU58Eo12Ydeh4DQ+nlJYrk6c91aXU1ii6PvxQDd
xJNaxUljcMW36zNpL1Qy7BISbEkh2kRCyPmV9OmDhlmGDJfZg0kGlRorga+q9HrJ
mI/kS2ajFdXy/9ovk38seIcHJRxpWawgN/ORuV5YX8D/y/O7Gb5Cc+l0Ai6Pe5At
pYjhIw428VQjyQg/L9zGM8oF+llegHH2V7MUfvqFOFRN45JR6bblohEt7x3TrS2j
U3ufXEGBhhwEEII1h6f2QaC6YUeyuQ==
=uA/X
-----END PGP SIGNATURE-----

--fqIB0bRxfTYxTb/F--

