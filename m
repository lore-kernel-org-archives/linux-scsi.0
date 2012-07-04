From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] virtio-scsi: hotplug support for virtio-scsi
Date: Wed, 04 Jul 2012 14:35:04 +0200
Message-ID: <4FF43878.3000207@redhat.com>
References: <1341294085-17164-1-git-send-email-mc@linux.vnet.ibm.com>
	<4FF2DC6C.1010506@redhat.com>
	<20120704041124.Horde.MN5WeZir309P8-qsGUCj3vA@imap.linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20120704041124.Horde.MN5WeZir309P8-qsGUCj3vA@imap.linux.ibm.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: mc@linux.vnet.ibm.com
Cc: stefanha@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, senwang@linux.vnet.ibm.com, zwanp@cn.ibm.com, linuxram@us.ibm.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

Il 04/07/2012 10:11, mc@linux.vnet.ibm.com ha scritto:
>>>
>>>
>>> Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
>>> Signed-off-by: Sen Wang <senwang@linux.vnet.ibm.com>
>>
>> The SoB lines are swapped.  Otherwise looks good.  Since you have to
>> respin, please add dropped event support too, it shouldn't be hard.
> 
> What does "The SoB lines are swapped" mean? should the changelog be
> placed after SoB lines?

No, the patch sender should be the last SoB line.  Sen Wang should hence
come before you, not after.

Paolo
