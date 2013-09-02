From: chandrashekar shastri <cshastri@oc2505588478.ibm.com>
Subject: Testing NPIV Feature with Qemu-KVM
Date: Mon, 2 Sep 2013 18:04:44 +0530
Message-ID: <20130902123444.GA25765@oc2505588478.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: linux-scsi@vger.kernel.org, qemu-devel@nongnu.org, linux-fsdevel@vger.kernel.org
Cc: hare@suse.de
List-Id: linux-scsi@vger.kernel.org

Hi All,

I am testing NPIV feature on upstream Qemu, I have configured the zone
and able to see the created vport on the storage array.

Since, I am learning on how to setup the NPIV, I haven't created the different zone for
the vport and the array, I just added in the existing zone. 

Now, how do pass the LUN to the qemu, from Dr. Hannes Reineckei mail thread I got to know that lspci command on the host doesn't show the virtual HBA.

I didn't understand why there is limitation on that and if I specify
/usr/libexec/qemu-kvm -enable-kvm Fedora19 -m 3000 -smp 2 -net nic -net
\ user -vnc 127.0.0.1:0 -drive if=scsi,file=/dev/sdj

How do I make sure that qemu is using the virtual HBA or (vport)?

Thanks,
Shastri
