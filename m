From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] virtio-scsi: Fix hotcpu_notifier use-after-free with
	virtscsi_freeze
Date: Tue, 17 Dec 2013 12:46:21 +0800
Message-ID: <52AFD71D.4000103@redhat.com>
References: <1382947263-22145-1-git-send-email-asias@redhat.com>
	<52A95882.2020000@redhat.com> <87zjo0maw3.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <87zjo0maw3.fsf@rustcorp.com.au>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, pbonzini@redhat.com, Asias He <asias@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 12/17/2013 11:09 AM, Rusty Russell wrote:
> Jason Wang <jasowang@redhat.com> writes:
>> > On 10/28/2013 04:01 PM, Asias He wrote:
>>> >> vqs are freed in virtscsi_freeze but the hotcpu_notifier is not
>>> >> unregistered. We will have a use-after-free usage when the notifier
>>> >> callback is called after virtscsi_freeze.
>>> >>
>>> >> Signed-off-by: Asias He <asias@redhat.com>
> Please include a Fixes: line, especially if you want the CC: stable.
>
> Thanks,
> Rusty.
>
>
 
Ok, will post V2 soon.
