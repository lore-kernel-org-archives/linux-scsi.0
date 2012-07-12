From: Stefan Hajnoczi <stefanha@gmail.com>
Subject: Re: [PATCH v4] virtio-scsi: hotplug support for virtio-scsi
Date: Thu, 12 Jul 2012 11:37:27 +0100
Message-ID: <CAJSP0QUUHC3ye0QWBGO3hBJ5RnsUVHumfVNUoMj+OZJDJEprPA@mail.gmail.com>
References: <1341479203-12058-1-git-send-email-mc@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1341479203-12058-1-git-send-email-mc@linux.vnet.ibm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Cong Meng <mc@linux.vnet.ibm.com>
Cc: stefanha@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, zwanp@cn.ibm.com, linuxram@us.ibm.com, senwang@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 5, 2012 at 10:06 AM, Cong Meng <mc@linux.vnet.ibm.com> wrote:
> This patch implements the hotplug support for virtio-scsi.
> When there is a device attached/detached, the virtio-scsi driver will be
> signaled via event virtual queue and it will add/remove the scsi device
> in question automatically.
>
> v2: handle no_event event
> v3: add handle event dropped, and typo fix
> v4: Cancel event works when exit. Coding type fix.
>
> Signed-off-by: Sen Wang <senwang@linux.vnet.ibm.com>
> Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
> ---
>  drivers/scsi/virtio_scsi.c  |  127 ++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/virtio_scsi.h |    9 +++
>  2 files changed, 135 insertions(+), 1 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
