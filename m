From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [PATCH v5 0/3] virtio-scsi driver
Date: Fri, 10 Feb 2012 11:00:14 +0000
Message-ID: <CAJSP0QV5bRzwPMfQTyMj34kiJ+to8Z7hJQxJrK5edG1dAHCr4Q@mail.gmail.com>
References: <1328440562-19425-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1328440562-19425-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org, Pekka Enberg <penberg@kernel.org>, "Michael S . Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: linux-scsi@vger.kernel.org

On Sun, Feb 5, 2012 at 11:15 AM, Paolo Bonzini <pbonzini@redhat.com> wr=
ote:
> This is the first implementation of the virtio-scsi driver, a virtual
> HBA that will be supported by KVM. =A0It implements a subset of the s=
pec,
> in particular it does not implement asynchronous notifications for ei=
ther
> LUN reset/removal/addition or CD-ROM media events, but it is already
> functional and usable.
>
> Other matching bits:
>
> - spec at http://people.redhat.com/pbonzini/virtio-spec.pdf
>
> - QEMU implementation at git://github.com/bonzini/qemu.git,
> =A0branch virtio-scsi
>
> Please review. =A0Getting this in 3.3 is starting to look like wishfu=
l thinking,
> but the possibility of regressions is obviously zero so I'm still dre=
aming.
> Otherwise, that would be 3.4.

Reviewed-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
